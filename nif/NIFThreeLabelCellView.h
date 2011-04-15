/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

/** 
 * UITableViewCell that has 2 additional labels (shown only if used): 
 * a bottom label (shown under the main label) and a right label (shown aligned to the right edge of the cell). 
 */
@interface NIFThreeLabelCellView : UITableViewCell {
	UILabel* mainLabel;

	UILabel* rightLabel;
	UIColor* rightLabelColor;
	UIColor* rightLabelSelectedColor;
	CGFloat rightTextMargin;
	
	UILabel* bottomLabel;
	UIColor* bottomLabelColor;
	UIColor* bottomLabelSelectedColor;
	CGFloat mainBottomTextPadding;
	
	CGFloat imageLabelPadding;
	
	CGFloat mainRightTextPadding;
	
	CGFloat rightTextAccessoryViewPadding;
}

@property (nonatomic, readonly) UILabel* mainLabel;
@property (nonatomic, readonly) UILabel* bottomLabel;
@property (nonatomic, readonly) UILabel* rightLabel;

@property (nonatomic, retain) NSString* rightText;
@property (nonatomic, retain) UIFont* rightTextFont;
@property (nonatomic, retain) UIColor* rightTextColor;
@property (nonatomic, retain) UIColor* rightTextSelectedColor;
@property (nonatomic, readwrite) CGFloat rightTextMargin;
@property (nonatomic, retain) NSString* bottomText;
@property (nonatomic, retain) UIFont* bottomTextFont;
@property (nonatomic, retain) UIColor* bottomTextColor;
@property (nonatomic, retain) UIColor* bottomTextSelectedColor;
@property (nonatomic, readwrite) CGFloat mainBottomTextPadding;
@property (nonatomic, readwrite) CGFloat mainRightTextPadding;
@property (nonatomic, readwrite) CGFloat rightTextAccessoryViewPadding;

- (NSString*)rightText;
- (void)setRightText:(NSString*)rightText;

- (UIFont*)rightTextFont;
- (void)setRightTextFont:(UIFont*)font;

- (UIColor*)rightTextColor;
- (void)setRightTextColor:(UIColor*)color;

- (UIColor*)rightTextSelectedColor;
- (void)setRightTextSelectedColor:(UIColor*)color;

- (CGFloat)rightTextMargin;
- (void)setRightTextMargin:(CGFloat)margin;

- (NSString*)bottomText;
- (void)setBottomText:(NSString*)text;

- (UIFont*)bottomTextFont;
- (void)setBottomTextFont:(UIFont*)font;

- (UIColor*)bottomTextColor;
- (void)setBottomTextColor:(UIColor*)color;

- (UIColor*)bottomTextSelectedColor;
- (void)setBottomTextSelectedColor:(UIColor*)color;

- (CGFloat)mainBottomTextPadding;
- (void)setMainBottomTextPadding:(CGFloat)value;

@property (nonatomic, assign) NSInteger mainNumberOfLines;
- (NSInteger)mainNumberOfLines;
- (void)setMainNumberOfLines:(NSInteger)numberOfLines;

- (void)setImage:(UIImage*)image;
- (UIImage*)image;

- (void)setText:(NSString*)text;
- (NSString*)text;

- (void)setTextColor:(UIColor*)color;
- (UIColor*)textColor;

- (void)setSelectedTextColor:(UIColor*)color;
- (UIColor*)selectedTextColor;

@end
