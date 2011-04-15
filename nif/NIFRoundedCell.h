/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

#import "NIFThreeLabelCellView.h"

/** 
 * Rounded background to be used with UITableViewCell. 
 * For grouped tables, not for plain ones. 
 */
@interface NIFRoundedCellBackground : UIView {
	// Weak ref to the cell this view is used with, since we need to retrieve cell position
	// (top of the group, middle or bottom)
	UITableViewCell* parentCell;
	
	UIColor* borderColor;
	UIColor* fillColor;
	CGFloat borderWidth;
	CGFloat roundness;
}

/** Designated initializer. */
- (id)initWithFrame:(CGRect)rect parentCell:(UITableViewCell*)parentCell;

/** Color of the border. RGB(187, 187, 187) by default. */
- (UIColor*)borderColor;
- (void)setBorderColor:(UIColor*)color;
@property (nonatomic, retain) UIColor* borderColor;

/** Fill color. White by default. */
- (UIColor*)color;
- (void)setColor:(UIColor*)color;
@property (nonatomic, retain) UIColor* color;

/** Rounded rect border width. 1.0 by default. */
- (CGFloat)borderWidth;
- (void)setBorderWidth:(CGFloat)width;
@property (nonatomic, assign) CGFloat borderWidth;

/** Radius of the rounded rect corners. 10.0 pixels by default*/
- (CGFloat)roundness;
- (void)setRoundness:(CGFloat)roundness;
@property (nonatomic, assign) CGFloat roundness;

@end

/** 
 * NIFThreeLabelCellView that is using NIFRoundedCellBackground for background. 
 */
@interface NIFRoundedCell : NIFThreeLabelCellView {
}

@property (nonatomic, readonly) NIFRoundedCellBackground* roundedBackground;
@property (nonatomic, readonly) NIFRoundedCellBackground* selectedRoundedBackground;

@end
