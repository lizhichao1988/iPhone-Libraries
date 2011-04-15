/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import "NIFWeakRef.h"

@implementation NIFWeakRef

- (id)initWithObject:(NSObject*)_obj {
	if (self = [super init]) {
		obj = _obj;
	}
	return self;
}

- (id)ref {
	return [[obj retain] autorelease];
}

- (void)invalidate {
	obj = nil;
	[self release];
}

- (NSUInteger)hash {
	if (obj) {
		return [obj hash];
	} else {
		return 0;
	}
}

- (BOOL)isEqual:(id)otherObj {
	if (obj) {
		return [obj isEqual:otherObj];
	} else {
		return NO;
	}
}

@end
