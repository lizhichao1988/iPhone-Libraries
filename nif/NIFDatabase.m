/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import "NIFDatabase.h"
#import "NIFLog.h"

@interface NIFDatabase ()
- (void)markUnused:(NIFDatabaseReusableStatement*)reusableStatement;
@end

//
//
//
@interface NIFDatabaseReusableStatement : NSObject {
	// Weak
	NIFDatabase* db; 
	
	NSString* sql;
	sqlite3_stmt* stmt;
}

- (id)initWithDatabase:(NIFDatabase*)_db sql:(NSString*)_sql;

- (void)markUnused;

@property (nonatomic, readonly) sqlite3_stmt* stmt;
@property (nonatomic, readonly) NSString* sql;

@end

@implementation NIFDatabaseReusableStatement

@synthesize stmt, sql;

- (id)initWithDatabase:(NIFDatabase*)_db sql:(NSString*)_sql {
	if (self = [super init]) {
		db = _db;
		sql = [_sql retain];
				
		const char* unused;
		int result = sqlite3_prepare_v2(
			[db handle], 
			[sql UTF8String], 
			-1, 
			&stmt, 
			&unused
		);
		if (result != SQLITE_OK) {
			NIF_ERROR(@"Unable to prepare SQLite query '%@': %d (%s)", sql, result, sqlite3_errmsg([db handle]));
			[self release];
			self = nil;
		}
	}
	return self;
}

- (void)dealloc {
	[sql release];
	
	if (stmt) {
		sqlite3_finalize(stmt);
	}
	
	[super dealloc];
}

- (void)markUnused {
	sqlite3_reset(stmt);
	sqlite3_clear_bindings(stmt);
	[db markUnused:self];
}

@end


//
//
//
@interface NIFDatabaseRecord ()
- (id)initWithDatabase:(NIFDatabase*)database stmt:(NIFDatabaseReusableStatement*)stmt params:(NSArray*)params;
- (BOOL)bind:(NSArray*)params;
@end

static char tempDir[1024];

//
//
//
@implementation NIFDatabase

- (id)initWithFileName:(NSString*)fileName readonly:(BOOL)readonly createIfDoesNotExist:(BOOL)create {

	NSAssert(!readonly || readonly && !create, @"You cannot request a DB to be created and opened as read only at the same time");
	
	if (self = [super init]) {
	
		reusableStatements = [[NSMutableDictionary alloc] init];
	
		if (!sqlite3_temp_directory) {
			strcpy(tempDir, [NSTemporaryDirectory() cStringUsingEncoding:NSUTF8StringEncoding]);
			sqlite3_temp_directory = tempDir;
		}
				
		NIF_INFO(@"SQLite temporary directory is set to '%s'", sqlite3_temp_directory);
	
		int result = sqlite3_open_v2(
			[fileName cStringUsingEncoding:NSUTF8StringEncoding], 
			&db,
			(readonly ? SQLITE_OPEN_READONLY : SQLITE_OPEN_READWRITE) 
			| (create ? SQLITE_OPEN_CREATE : 0),
			NULL
		);
		if (result != SQLITE_OK) {
			NIF_ERROR(@"Error opening an SQLite DB: %d", result);
			return nil;
		}
		
		NSString* error = nil;
		if (![self 
			exec:@"PRAGMA journal_mode = TRUNCATE; PRAGMA locking_mode = EXCLUSIVE; PRAGMA synchronous = OFF; PRAGMA temp_store = MEMORY;" 
			errorDescription:&error]
		) {
			NIF_ERROR(@"Unable to execute SQLite pragma: %@", error);
		}	
		
		[[NSNotificationCenter defaultCenter] 
			addObserver:self 
			selector:@selector(didReceiveMemoryWarning) 
			name:UIApplicationDidReceiveMemoryWarningNotification 
			object:nil
		];		
	}
	return self;
}

- (void)close {
	[reusableStatements release];
	reusableStatements = nil;

	if (db) {
	
		[[NSNotificationCenter defaultCenter] 
			removeObserver:self 
			name:UIApplicationDidReceiveMemoryWarningNotification 
			object:nil
		];
				
		int result = sqlite3_close(db);
		if (result != SQLITE_OK) {
			NSLog(@"Error closing an SQLite DB: %d", result);
		}
		db = NULL;
	}
}

- (void)dealloc {
	
	[self close];
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning {

	[reusableStatements removeAllObjects];
	
	int released = sqlite3_release_memory(INT_MAX);
	
	NSLog(@"Released %d byte(s) of SQLite caches", released);
}

- (sqlite3*)handle {
	return db;
}

- (NIFDatabaseRecord*)query:(NSString*)sql {
	return [self query:sql params:nil];
}

- (NIFDatabaseRecord*)query:(NSString*)sql params:(NSObject*)first, ... {
	NSMutableArray *params;
	if (first) {
		params = [NSMutableArray arrayWithObject:first];
		
		va_list args;
		va_start(args, first);
		NSObject* p;
		while (p = va_arg(args, NSObject*)) {			
			[params addObject:p];
		}
		va_end(args);
	} else {
		params = nil;
	}
	
	NIFDatabaseReusableStatement* reusableStmt = nil;
	NSMutableArray* l = [reusableStatements objectForKey:sql];
	if (!l || [l count] == 0) {
		reusableStmt = [[[NIFDatabaseReusableStatement alloc] initWithDatabase:self sql:sql] autorelease];
	} else {
		reusableStmt = [[[l lastObject] retain] autorelease];
		[l removeLastObject];
	}
	
	if (!reusableStmt) {
		return nil;
	}
	
	NIFDatabaseRecord *stmt = [[[NIFDatabaseRecord alloc] initWithDatabase:self stmt:reusableStmt params:params] autorelease];
	
	return stmt;
}

- (void)markUnused:(NIFDatabaseReusableStatement*)reusableStatement {
	NSMutableArray* l = [reusableStatements objectForKey:reusableStatement.sql];
	if (!l) {
		l = [[[NSMutableArray alloc] init] autorelease];
		[reusableStatements setObject:l forKey:reusableStatement.sql];
	}
	[l addObject:reusableStatement];
}

- (BOOL)exec:(NSString*)sql errorDescription:(NSString**)errorDescription {
	NSData* data = [[sql stringByAppendingString:@"\0"] dataUsingEncoding:NSUTF8StringEncoding];
	if (!data) {
		NIF_ERROR(@"Unable to obtain a UTF-8 encoded string from supplied SQL string");
		return NO;
	}
	
	char* errorString = NULL;
	
	BOOL result = (sqlite3_exec(db, [data bytes], NULL, NULL, &errorString) == SQLITE_OK);
	
	if (errorString) {
		if (errorDescription) {
			*errorDescription = [[[NSString stringWithUTF8String:errorString] copy] autorelease];
		}
		sqlite3_free(errorString);
	}
	
	return result;
}

- (BOOL)begin {
	return [self exec:@"BEGIN TRANSACTION" errorDescription:nil];
}

- (BOOL)commit {
	return [self exec:@"COMMIT TRANSACTION" errorDescription:nil];
}

- (BOOL)rollback {
	return [self exec:@"ROLLBACK TRANSACTION" errorDescription:nil];
}

- (NSInteger)lastInsertRowId {
	return sqlite3_last_insert_rowid(db);
}

- (NSInteger)schemaVersion {
	NIFDatabaseRecord* r = [self query:@"PRAGMA schema_version"];
	[r next];
	if ([r isError]) {
		NIF_ERROR(@"Unable to retrieve datbase schema version, using 0");
		return 0;
	}
	
	return [r intAtCol:0];
}

- (NSInteger)userVersion {
	NIFDatabaseRecord* r = [self query:@"PRAGMA user_version"];
	[r next];
	if ([r isError]) {
		NIF_ERROR(@"Unable to retrieve datbase user version, using 0");
		return 0;
	}
	
	return [r intAtCol:0];
}

@end

//
//
//
@implementation NIFDatabaseRecord 

- (id)initWithDatabase:(NIFDatabase*)database stmt:(NIFDatabaseReusableStatement*)_reusableStatement params:(NSArray*)params {
	if (self = [super init]) {
		
		reusableStatement = [_reusableStatement retain];
		stmt = reusableStatement.stmt;
				
		if (params && ![self bind:params]) {
			[self release];
			return nil;
		}		
	}
	return self;
}

- (void)dealloc {
	[reusableStatement markUnused];
	[reusableStatement release];
	
	[super dealloc];
}

- (BOOL)next {
	if (!self || !stmt || eof || error) {
		return NO;
	}
		
	int result = sqlite3_step(stmt);
	if (result == SQLITE_ROW) {
#ifdef DEBUG	
		fetchedRowCount++;
#endif		
		return YES;
	} else if (result == SQLITE_DONE) {
	
#ifdef DEBUG	
		//
		// In debug mode keeping an eye on the proper usage of indices
		//
		int sortCount = sqlite3_stmt_status(stmt, SQLITE_STMTSTATUS_SORT, 1);
		if (sortCount > 0) {
			NIF_TRACE(@"Warning: statement sort count is %d for the query '%s'. Make sure you have needed indices.", sortCount, sqlite3_sql(stmt));
		}
		int fullScanSteps = sqlite3_stmt_status(stmt, SQLITE_STMTSTATUS_FULLSCAN_STEP, 1);
		if (fullScanSteps > fetchedRowCount) {
			NIF_TRACE(@"Warning: statement full scan steps is %d for the query '%s' resulting in %d row(s). Make sure you have needed indices.", fullScanSteps, sqlite3_sql(stmt), fetchedRowCount);
		}
#endif
		eof = YES;
	} else {		
		NIF_TRACE(@"SQLite step error: %d", result);
		error = YES;
	}
	return NO;
}

- (BOOL)isEof {
	return eof;
}

- (BOOL)isError {
	return (self == nil) || error;
}

- (BOOL)bind:(NSArray*)params {
	NSObject *p = nil;
	int index = 1;
	int result;
	for (p in params) {
		if ([p isKindOfClass:[NSNull class]]) {
			result = sqlite3_bind_null(stmt, index);
			if (result != SQLITE_OK) {
				NIF_ERROR(@"Unable to bind a null param #%d of an SQLite statement: %d", index, result);
				break;
			}
		}
		else if ([p isKindOfClass:[NSNumber class]]) {
			NSNumber *num = (NSNumber*)p;
			result = sqlite3_bind_int(stmt, index, [num intValue]);
			if (result != SQLITE_OK) {
				NIF_ERROR(@"Unable to bind an int parameter #%d of an SQLite statement: %d", index, result);
				break;
			}
		} 
		else if ([p isKindOfClass:[NSString class]]) {
			NSString *str = (NSString*)p;
			result = sqlite3_bind_text(stmt, index, [str UTF8String], -1, SQLITE_TRANSIENT);
			if (result != SQLITE_OK) {
				NIF_ERROR(@"Unable to bind a string parameter #%d of an SQLite statement: %d", index, result);
				break;
			}
		}
		else if ([p isKindOfClass:[NSData class]]) {
			NSData* d = (NSData*)p;
			result = sqlite3_bind_blob(stmt, index, [d bytes], [d length], SQLITE_TRANSIENT);
			if (result != SQLITE_OK) {
				NIF_ERROR(@"Unable to bind a blob parameter #%d of an SQLite statement: %d", index, result);
				break;
			}
		}
		else {
			NIF_ERROR(@"Unable to bind a paramater #%d: value of unsupported type is supplied (%@)", index, [p class]);
			break;
		}
		
		index++;
	}
	if (p != nil)
		return NO;

	return YES;
}

- (NSInteger)intAtCol:(NSInteger)index {
	return sqlite3_column_int(stmt, index);	
}

- (NSString*)stringAtCol:(NSInteger)index {
	const char* s = (const char*)sqlite3_column_text(stmt, index);
	if (s)
		return [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
	else
		return nil;
}

- (NSData*)dataAtCol:(NSInteger)index {
	const void* b = sqlite3_column_blob(stmt, index);
	if (b)
		return [NSData dataWithBytes:b length:sqlite3_column_bytes(stmt, index)];
	else
		return nil;
}

@end
