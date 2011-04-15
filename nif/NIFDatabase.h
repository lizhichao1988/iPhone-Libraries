/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

#import "sqlite3.h"

@class NIFDatabaseRecord;

/** SQLite database wrapper. */
@interface NIFDatabase : NSObject {
	sqlite3 *db;
	
	NSMutableDictionary* reusableStatements;
}

- (id)initWithFileName:(NSString*)fileName readonly:(BOOL)readonly createIfDoesNotExist:(BOOL)create;

- (sqlite3*)handle;

- (NIFDatabaseRecord*)query:(NSString*)sql;
- (NIFDatabaseRecord*)query:(NSString*)sql params:(NSObject*)first, ...;

- (BOOL)begin;
- (BOOL)commit;
- (BOOL)rollback;

/** Execute several SQL statements in one string. */
- (BOOL)exec:(NSString*)sql errorDescription:(NSString**)errorDescription;

/** 
 * ID of the record inserted by the most recently executed INSERT statement. 
 * (A wrapper for sqlite3_last_insert_rowid() function). 
 */
- (NSInteger)lastInsertRowId;

/** Shortcut for PRAGMA schema_version */
- (NSInteger)schemaVersion;

/** Shortcut for PRAGMA user_version */
- (NSInteger)userVersion;

- (void)close;

@end

@class NIFDatabaseReusableStatement;

/** Wrapper for the result set ('statement' in SQLite terms). */
@interface NIFDatabaseRecord : NSObject {
	NIFDatabaseReusableStatement* reusableStatement;
	sqlite3_stmt *stmt;
	BOOL eof;
	BOOL error;
	
#ifdef DEBUG	
	NSInteger fetchedRowCount;
#endif
}

/** 
 * Fetches the next record so fields can be accessed using intAtCol:, stringAtCol:, dataAtCol: methods.
 * Note that initially after the NIFDatabaseRecord is returned by query: or query:params: methods of NIFDatabase 
 * no row is fetched for SELECT queries and no INSERT/UPDATE is performed. I.e. next must be always called at least once.
 */
- (BOOL)next;

/** YES, if last call of the next method was unable to fetch a row because there are no more rows available. */
- (BOOL)isEof;

/** 
 * YES, if it was unable to fetch the next record. 
 * Also returns YES if self == nil, which could be convenient in INSERT queries, i.e. instead of
 *
 * [r next];
 * if (!r || [r isError]) {
 *     // ... 
 * 
 * The code can be just 
 * [r next];
 * if ([r isError]) {
 *     // ...  
 */
- (BOOL)isError;

- (NSInteger)intAtCol:(NSInteger)index;
- (NSString*)stringAtCol:(NSInteger)index;
- (NSData*)dataAtCol:(NSInteger)index;

@end
