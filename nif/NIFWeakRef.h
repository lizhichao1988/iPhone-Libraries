/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import <Foundation/Foundation.h>

/**
 * Kind of a weak reference. Of course it requires some assistance from objects that are
 * referenced by it (need to call -(void)invalidate when the referenced object is deallocated, 
 * which assumes that the object knows all weak references pointing on it).
 */
@interface NIFWeakRef : NSObject {
	NSObject* obj;
}

- (id)initWithObject:(NSObject*)obj;

/** Target reference (retained and autoreleased). */
- (id)ref;

/** Releases target reference. Method ref is going to return nil after this call. */ 
- (void)invalidate;

@end

