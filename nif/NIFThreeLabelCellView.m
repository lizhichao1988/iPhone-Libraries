/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import "NIFThreeLabelCellView.h"

#import <Availability.h>

//
// Private methods
//
@interface NIFThreeLabelCellView () 
- (void)_createMainLabel;
- (void)_updateMainLabelColor;
- (void)_createRightLabel;
- (void)_updateRightLabelColor;
- (void)_createBottomLabel;
- (void)_updateBottomLabelColor;
@end

//
// Actual implementation
//
@implementation NIFThreeLabelCellView

@synthesize mainRightTextPadding, rightTextAccessoryViewPadding;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		rightLabelColor = [[UIColor blackColor] retain];
		rightLabelSelectedColor = [[UIColor whiteColor] retain];
		bottomLabelColor = [[UIColor blackColor] retain];
		bottomLabelSelectedColor = [[UIColor whiteColor] retain];
		
		imageLabelPadding = 10; // TODO: make a parameter or calculate somehow
		mainRightTextPadding = 10;
		rightTextAccessoryViewPadding = 15;
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	[self _updateMainLabelColor];
	[self _updateRightLabelColor];
	[self _updateBottomLabelColor];
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	if (mainLabel)
		mainLabel.text = nil;
	if (bottomLabel)
		bottomLabel.text = nil;
	if (rightLabel)
		rightLabel.text = nil;
		
	[self setNeedsLayout];
}

- (void)dealloc {
	[rightLabelColor release];
	[rightLabelSelectedColor release];
	[bottomLabelColor release];
	[bottomLabelSelectedColor release];
	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGRect contentRect = self.contentView.bounds;
	contentRect.origin.x += round(self.indentationWidth * (self.indentationLevel + 1));
	contentRect.size.width -= round(self.indentationWidth * (self.indentationLevel + 1));
		
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30000
	if (self.imageView.image) {
		CGSize imageSize = self.imageView.image.size;
		contentRect.origin.x += imageSize.width + imageLabelPadding;
		contentRect.size.width -= imageSize.width + imageLabelPadding;
	}
#else
	if (self.image) {
		CGSize imageSize = [self.image size];
		contentRect.origin.x += imageSize.width + imageLabelPadding;
		contentRect.size.width -= imageSize.width + imageLabelPadding;
	}
#endif
		
	if (self.accessoryView) {
		contentRect.size.width -= rightTextAccessoryViewPadding;
	}
	
	if (rightLabel && rightLabel.text) {	
		contentRect.size.width -= rightTextMargin;
	
		CGSize preferredSize = [rightLabel 
			sizeThatFits:CGSizeMake(
				(int)(contentRect.size.width / 2), 
				contentRect.size.height
			)
		];
		preferredSize.width += mainRightTextPadding;
		rightLabel.frame = CGRectMake(
			contentRect.origin.x + contentRect.size.width - preferredSize.width,
			contentRect.origin.y + (int)((contentRect.size.height - preferredSize.height) / 2),
			preferredSize.width,
			preferredSize.height
		);
		contentRect.size.width -= preferredSize.width;
	}
	
	if (mainLabel && (!bottomLabel || !bottomLabel.text || [bottomLabel.text isEqualToString:@""])) {		
		mainLabel.frame = contentRect;
	} else if (bottomLabel && !mainLabel) {
		bottomLabel.frame = contentRect;
	} else if (mainLabel && bottomLabel) {
		CGSize mainSize = [mainLabel sizeThatFits:contentRect.size];
		CGSize bottomSize = [bottomLabel sizeThatFits:contentRect.size];
		int y = (int)(contentRect.origin.y + (contentRect.size.height - ceil(mainSize.height) - ceil(mainBottomTextPadding) - ceil(bottomSize.height)) / 2 + 0.5);
		mainLabel.frame = CGRectMake(
			contentRect.origin.x,
			contentRect.origin.y + y, 
			contentRect.size.width,
			mainSize.height
		);
		y += ceil(mainSize.height) + ceil(mainBottomTextPadding);
		bottomLabel.frame = CGRectMake(
			contentRect.origin.x,
			contentRect.origin.y + y,
			contentRect.size.width,
			bottomSize.height
		);
	}
}

//
// Right text label stuff
//

- (void)_createRightLabel {
	if (!rightLabel) {
		rightLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		rightLabel.opaque = NO;
		rightLabel.backgroundColor = [UIColor clearColor];
		rightLabel.textAlignment = UITextAlignmentRight;
		[self _updateRightLabelColor];
		[self.contentView addSubview:rightLabel];
	}
}

- (NSString*)rightText {
	if (!rightLabel)
		return nil;
	else 
		return rightLabel.text;
}

- (void)setRightText:(NSString*)text {
	if (text) {
		[self _createRightLabel];
		rightLabel.text = text;
		[self setNeedsLayout];
	}
}

- (UIFont*)rightTextFont {
	if (!rightLabel)
		return nil;
	else
		return rightLabel.font;
}

- (void)setRightTextFont:(UIFont*)font {
	[self _createRightLabel];
	rightLabel.font = font;
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

- (UIColor*)rightTextColor {
	return [[rightLabelColor retain] autorelease];
}

- (void)setRightTextColor:(UIColor*)color {
	[color retain];
	[rightLabelColor release];
	rightLabelColor = color;
	
	[self _updateRightLabelColor];
}

- (UIColor*)rightTextSelectedColor {
	return [[rightLabelSelectedColor retain] autorelease];
}

- (void)setRightTextSelectedColor:(UIColor*)color {
	[color retain];
	[rightLabelSelectedColor release];
	rightLabelSelectedColor = color;
	
	[self _updateRightLabelColor];
}

- (void)_updateRightLabelColor {
	if (rightLabel) {
		rightLabel.textColor = self.selected ? rightLabelSelectedColor : rightLabelColor;
	}
}

- (CGFloat)rightTextMargin {
	return rightTextMargin;
}

- (void)setRightTextMargin:(CGFloat)margin {
	rightTextMargin = margin;
	[self setNeedsLayout];
}

//
// Main text label stuff
//

- (void)_createMainLabel {
	if (!mainLabel) {
		mainLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		mainLabel.opaque = NO;
		mainLabel.backgroundColor = [UIColor clearColor];
		[self _updateMainLabelColor];
		[self.contentView addSubview:mainLabel];
	}
}

- (void)_updateMainLabelColor {
	if (mainLabel) {
		mainLabel.highlighted = self.selected;
	}
}

- (NSString*)text {
	if (!mainLabel)
		return nil;
	else 
		return mainLabel.text;
}

- (void)setText:(NSString*)text {
	[self _createMainLabel];
	mainLabel.text = text;
	[self setNeedsLayout];
}

- (UIFont*)font {
	if (!mainLabel)
		return nil;
	else
		return mainLabel.font;
}

- (void)setFont:(UIFont*)font {
	[self _createMainLabel];
	mainLabel.font = font;
}

- (void)setTextColor:(UIColor*)color {
	[self _createMainLabel];
	mainLabel.textColor = color;
	
	[self _updateMainLabelColor];
}

- (UIColor*)textColor {
	[self _createMainLabel];
	return mainLabel.textColor;
}

- (void)setSelectedTextColor:(UIColor*)color {
	[self _createMainLabel];
	mainLabel.highlightedTextColor = color;
	
	[self _updateMainLabelColor];
}

- (UIColor*)selectedTextColor {
	[self _createMainLabel];
	return mainLabel.highlightedTextColor;
}

//
// Bottom text label
//

- (void)_createBottomLabel {
	if (!bottomLabel) {
		bottomLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		bottomLabel.opaque = NO;
		bottomLabel.backgroundColor = [UIColor clearColor];
		
		bottomLabel.textAlignment = UITextAlignmentLeft;
		[self _updateBottomLabelColor];
		[self.contentView addSubview:bottomLabel];
	}
}

- (NSString*)bottomText {
	if (!bottomLabel)
		return nil;
	else 
		return bottomLabel.text;
}

- (void)setBottomText:(NSString*)text {
	if (text) {
		[self _createBottomLabel];
		bottomLabel.text = text;
		[self setNeedsLayout];
	}
}

- (UIFont*)bottomTextFont {
	if (!bottomLabel)
		return nil;
	else
		return bottomLabel.font;
}

- (void)setBottomTextFont:(UIFont*)font {
	[self _createBottomLabel];
	bottomLabel.font = font;
	[self setNeedsDisplay];
}

- (UIColor*)bottomTextColor {
	return [[bottomLabelColor retain] autorelease];
}

- (void)setBottomTextColor:(UIColor*)color {
	[color retain];
	[bottomLabelColor release];
	bottomLabelColor = color;
	
	[self _updateBottomLabelColor];
}

- (UIColor*)bottomTextSelectedColor {
	return [[bottomLabelSelectedColor retain] autorelease];
}

- (void)setBottomTextSelectedColor:(UIColor*)color {
	[color retain];
	[bottomLabelSelectedColor release];
	bottomLabelSelectedColor = color;
	
	[self _updateBottomLabelColor];
}

- (void)_updateBottomLabelColor {
	if (bottomLabel) {
		bottomLabel.textColor = self.selected ? bottomLabelSelectedColor : bottomLabelColor;
	}
}

- (CGFloat)mainBottomTextPadding {
	return mainBottomTextPadding;
}

- (void)setMainBottomTextPadding:(CGFloat)value {	
	mainBottomTextPadding = value;
	[self setNeedsLayout];
}

- (NSInteger)mainNumberOfLines {
	if (mainLabel) {
		return mainLabel.numberOfLines;
	} else {
		return 0;
	}
}

- (void)setMainNumberOfLines:(NSInteger)numberOfLines {
	[self _createMainLabel];
	mainLabel.numberOfLines = numberOfLines;
}

- (UILabel*)mainLabel {
	[self _createMainLabel];
	return [[mainLabel retain] autorelease];
}

- (UILabel*)bottomLabel {
	[self _createBottomLabel];
	return [[bottomLabel retain] autorelease];
}

- (UILabel*)rightLabel {
	[self _createRightLabel];
	return [[rightLabel retain] autorelease];
}

- (void)setImage:(UIImage*)image {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30000
	super.imageView.image = image;
#else
	[super setImage:image];
#endif
	[self setNeedsLayout];
}

- (UIImage*)image {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30000
	return super.imageView.image;
#else
	return super.image;
#endif
}

@end
