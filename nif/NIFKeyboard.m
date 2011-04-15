/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import "NIFKeyboard.h"
#import "NIFLog.h"

@interface NIFKeyboardWeakRef : NSObject {
	id ref;
}

- (id)initWithId:(id)ref;
- (id)ref;

@end

@implementation NIFKeyboardWeakRef

- (id)initWithId:(id)_ref {
	if (self = [super init]) {
		ref = _ref;
	}
	return self;
}

- (id)ref {
	return ref;
}

- (BOOL)isEqual:(id)obj {
	return [obj ref] == ref;
}

- (NSUInteger)hash {
	return [ref hash];
}

@end

@implementation NIFKeyboard

static NIFKeyboard* sharedInstance;

+ (NIFKeyboard*)shared {
	if (!sharedInstance) {
		sharedInstance = [[NIFKeyboard alloc] init];
	}
	return sharedInstance;
}

- (void)keyboardDidShow:(NSNotification*)n {

	hidden = NO;
		
	[[[n userInfo] objectForKey:UIKeyboardCenterEndUserInfoKey] getValue:&center];
	
	CGRect bounds;
	[[[n userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&bounds];
	size = bounds.size;
	
	for (NIFKeyboardWeakRef* r in targets) {
		[[r ref] setNeedsLayout];
	}	
}

- (void)keyboardDidHide:(NSNotification*)n {
	hidden = YES;	
	
	for (NIFKeyboardWeakRef* r in targets) {
		[[r ref] setNeedsLayout];
	}
}

- (id)init {
	if (self = [super init]) {
		targets = [[NSMutableArray alloc] init];
		
		[[NSNotificationCenter defaultCenter] 
			addObserver:self
			selector:@selector(keyboardDidShow:) 
			name:UIKeyboardDidShowNotification 
			object:nil
		];
		
		[[NSNotificationCenter defaultCenter] 
			addObserver:self
			selector:@selector(keyboardDidHide:) 
			name:UIKeyboardDidHideNotification 
			object:nil
		];
		
		hidden = YES;
	}
	return self;
}

- (void)dealloc {

	[[NSNotificationCenter defaultCenter] 
		removeObserver:self
		name:UIKeyboardDidHideNotification 
		object:nil
	];
	
	[[NSNotificationCenter defaultCenter] 
		removeObserver:self
		name:UIKeyboardDidShowNotification 
		object:nil
	];		

	[targets release];
	[super dealloc];
}

- (void)addTarget:(id)target {
	[targets addObject:[[[NIFKeyboardWeakRef alloc] initWithId:target] autorelease]];
}

- (void)removeTarget:(id)target {
	[targets removeObject:[[[NIFKeyboardWeakRef alloc] initWithId:target] autorelease]];
}

- (BOOL)isHidden {
	return hidden;
}

- (CGFloat)keyboardTopForView:(UIView*)view {
	if (hidden) {
		CGRect r = view.bounds;
		return r.origin.y + r.size.height;
	} else {
	
		//
		// Need to convert keyboard top Y coordinate from screen coordinates into the view coordinates.
		// Technically we should use [view convetPoint:ceter fromView:nil], but there is a problem with this in 
		// landscape on the device (simulator works ok). 
		//
		// Instead we find the highest parent view that is not view's window and convert it from there. 
		// This is a potential source of problems with future firmwares, but works for now.
		//
		
		UIView* parent = view;
		while ([parent superview] != [view window]) {
			parent = [parent superview];
		}
		CGPoint p = [parent convertPoint:center toView:view];
		return round(p.y - size.height / 2);
	}
}

- (CGSize)size {
	return size;
}

- (CGPoint)center {
	return center;
}

@end
