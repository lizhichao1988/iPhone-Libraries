/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import "NIFSearchBarCell.h"

#import "NIFLog.h"

#define kNIFSearchBarCell_DefaultCancelButtonFont [UIFont fontWithName:@"Helvetica-Bold" size:12]

#define kNIFSearchBarCell_DefaultSearchFieldFont [UIFont fontWithName:@"Helvetica" size:14]

@interface NIFSearchBarCell_TextField : UITextField {
	UIEdgeInsets insets;
}

@end

@implementation NIFSearchBarCell_TextField

- (id)init {
	UIImage* backgroundImage = [UIImage imageNamed:@"search-field-background.png"];
	CGSize s = backgroundImage.size;
	if (self = [super initWithFrame:CGRectMake(0, 0, s.width, s.height)]) {
	
		self.font = kNIFSearchBarCell_DefaultSearchFieldFont;
		
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.background = [backgroundImage stretchableImageWithLeftCapWidth:s.width/2  topCapHeight:0];
		insets = UIEdgeInsetsMake(7, 5, 1, 5);
		
		self.clearButtonMode = UITextFieldViewModeAlways;
		self.clearsOnBeginEditing = YES;
		
		self.autocapitalizationType = UITextAutocorrectionTypeNo;
		self.autocorrectionType = UITextAutocorrectionTypeNo;
		
		self.enablesReturnKeyAutomatically = NO;
		self.returnKeyType = UIReturnKeyDone;
		self.placeholder = @"Search";
		
		UIImageView* magGlassView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-mag-glass.png"]] autorelease];
		self.leftView = magGlassView;
		self.leftViewMode = UITextFieldViewModeAlways;
	}
	return self;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	return UIEdgeInsetsInsetRect([super editingRectForBounds:bounds], insets);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
	return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], insets);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
	CGSize s = ((UIImageView*)self.leftView).image.size;
	CGFloat marginLeft = 7;
	CGFloat marginTop = 2;
	return CGRectMake(
		bounds.origin.x + marginLeft, 
		round(bounds.origin.y + marginTop + (bounds.size.height - marginTop - s.height) / 2),
		s.width,
		s.height
	);
}

@end

//
//
//

@interface NIFSearchBarCell_BackgroundView : UIView {
	UIColor* tintColor;
}

@property (nonatomic, retain) UIColor* tintColor;

@end

@implementation NIFSearchBarCell_BackgroundView

@synthesize tintColor;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.tintColor = [UIColor colorWithRed:34 green:0 blue:0 alpha:0];
		self.clearsContextBeforeDrawing = YES;
	}
	return self;
}

- (void)drawRect:(CGRect)r {
	CGContextRef c = UIGraphicsGetCurrentContext();
	[tintColor setFill];
	CGContextFillRect(c, self.bounds);
}

- (void)setTintColor:(UIColor*)color {
	[color retain];
	[tintColor release];
	tintColor = color;
	
	[self setNeedsDisplay];
}

@end

//
//
//
@interface NIFSearchBarCell () <UITextFieldDelegate>
@end

//
//
//
@implementation NIFSearchBarCell

@synthesize delegate;

- (void)orientationDidChange:(id)unused {
	//
	// Trying to workaround a problem with layout on orientation change happening 
	// when index is shown for the table view where this cell is in
	//
	[self setNeedsLayout];
	[self.superview setNeedsLayout];
	[self.superview.superview setNeedsLayout];
}

- (BOOL)commonInit {

	UIImage* backgroundImage = [UIImage imageNamed:@"search-bar-background.png"];
	background = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
	[self addSubview:background];		
//!	self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];		
//!	self.selectedBackgroundView = [[[NIFSearchBarCell_BackgroundView alloc] initWithFrame:CGRectZero] autorelease];		
						
	textField = [[[NIFSearchBarCell_TextField alloc] init] autorelease];
	textField.delegate = self;
	textField.clearsOnBeginEditing = NO;
//!	[self.contentView addSubview:textField];
	[self addSubview:textField];
	
	UIImage* cancelButtonBackground = [UIImage imageNamed:@"search-cancel-button.png"];
	cancelButtonSize = cancelButtonBackground.size;
	UIImage* stretchableCancelButtonBackground = [cancelButtonBackground stretchableImageWithLeftCapWidth:cancelButtonSize.width / 2 topCapHeight:0];
	cancelButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cancelButtonSize.width, cancelButtonSize.height)] autorelease];
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton setBackgroundImage:stretchableCancelButtonBackground forState:UIControlStateNormal];
	
	[cancelButton addTarget:self action:@selector(didTapCancel:) forControlEvents:UIControlEventTouchUpInside];
	
	
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30000		
	cancelButton.titleLabel.font = kNIFSearchBarCell_DefaultCancelButtonFont;
#else		
	cancelButton.font = kNIFSearchBarCell_DefaultCancelButtonFont;
#endif
	
//!	[self.contentView addSubview:cancelButton];
	[self addSubview:cancelButton];
	
	insets = UIEdgeInsetsMake(0, 10, 0, 10);
	textFieldCancelButtonPadding = 10;
	
	[[NSNotificationCenter defaultCenter] 
		addObserver:self 
		selector:@selector(orientationDidChange:) 
		name:UIDeviceOrientationDidChangeNotification 
		object:nil
	];				

	return YES;
}

- (id)initWithCoder:(NSCoder*)decoder {
	if (self = [super initWithCoder:decoder]) {
		if (![self commonInit]) {
			[self release];
			self = nil;
		}
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame  {
//!    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
	if (self = [super initWithFrame:frame ]) {
		if (![self commonInit]) {
			[self release];
			self = nil;
		}	
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] 
		removeObserver:self 
		name:UIDeviceOrientationDidChangeNotification 
		object:nil
	];		

    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	// Disable selection
}

- (void)resizeAnimated:(BOOL)animated {

	if (animated) {
		[UIView beginAnimations:@"resize" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
	
//~	CGRect r = UIEdgeInsetsInsetRect(self.contentView.bounds, insets);
	CGRect r = UIEdgeInsetsInsetRect(self.bounds, insets);

//!	
	background.frame = self.bounds;
	
	CGRect newFrame;
	
	if (cancelButtonShown) {
		newFrame = CGRectMake(
			round(r.origin.x + r.size.width - cancelButtonSize.width),
			round(r.origin.y + (r.size.height - cancelButtonSize.height) / 2),
			cancelButtonSize.width,
			cancelButtonSize.height
		);
	} else {
		newFrame = CGRectMake(
			round(r.origin.x + r.size.width + textFieldCancelButtonPadding),
			round(r.origin.y + (r.size.height - cancelButtonSize.height) / 2),
			cancelButtonSize.width,
			cancelButtonSize.height
		);
	}
	if (!CGRectEqualToRect(newFrame, cancelButton.frame)) {
		cancelButton.frame = newFrame;
	}
	
	if (cancelButton.hidden == cancelButtonShown) {
		cancelButton.hidden = !cancelButtonShown;
	}
	
	CGSize textFieldSize = textField.background.size;
	
	textFieldSize.width = cancelButtonShown ? r.size.width - (cancelButtonSize.width + textFieldCancelButtonPadding) : r.size.width;
	
	newFrame = CGRectMake(
		r.origin.x,
		round(r.origin.y + (r.size.height - textFieldSize.height) / 2),
		textFieldSize.width,
		textFieldSize.height
	);
	
	if (!CGRectEqualToRect(newFrame, textField.frame)) {
		textField.frame = newFrame;
	}
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)layoutSubviews {	
	[super layoutSubviews];
	
	[self resizeAnimated:NO];
}

- (void)setShowsCancelButton:(BOOL)shows animated:(BOOL)animated {
	cancelButtonShown = shows;
	[self resizeAnimated:animated];
	if (!shows && [textField isFirstResponder]) {
		[textField resignFirstResponder];
	}
}

- (NSString*)text {
	return textField.text;
}

- (void)setText:(NSString*)text {
	textField.text = text;
}

- (UIColor*)tintColor {
//	return ((NIFSearchBarCell_BackgroundView*)self.backgroundView).tintColor;
	return [UIColor clearColor];
}

- (void)setTintColor:(UIColor*)color {
//	((NIFSearchBarCell_BackgroundView*)self.backgroundView).tintColor = color;	
}


#pragma -
#pragma UITextViewDelegate

- (void)textFieldDidBeginEditing:(UITextField*)textField {
	if ([delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
		[delegate searchBarTextDidBeginEditing:self];
	}
}

- (BOOL)textFieldShouldEndEditing:(UITextField*)textField {
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField {
	if ([delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
		[delegate searchBarTextDidEndEditing:self];	
	}
}

- (BOOL)textField:(UITextField*)_textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
	if ([delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
		[delegate searchBar:self textDidChange:[textField text]];
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	if ([delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
		[delegate searchBarSearchButtonClicked:self];
	}
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField*)textField {
	if ([delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
		[delegate searchBar:self textDidChange:@""];
	}
	return YES;
}

#pragma -

- (void)didTapCancel:(id)unused {
	if ([delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
		[delegate searchBarCancelButtonClicked:self];
	}
}

@end
