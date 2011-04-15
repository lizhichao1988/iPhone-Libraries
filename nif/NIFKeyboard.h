/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

/** Tracks keyboard status, its size and position. */
@interface NIFKeyboard : NSObject {

	NSMutableArray* targets;
	
	BOOL hidden;	
	CGSize size;
	CGPoint center;
}

+ (NIFKeyboard*)shared;

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;

- (BOOL)isHidden;
- (CGFloat)keyboardTopForView:(UIView*)view;
- (CGSize)size;
- (CGPoint)center;

@end
