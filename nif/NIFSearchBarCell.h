/*
 * Neusis iPhone Framework.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

@class NIFSearchBarCell;

@protocol NIFSearchBarCellDelegate <NSObject>
@optional
- (void)searchBarSearchButtonClicked:(NIFSearchBarCell*)searchBar;
- (void)searchBarCancelButtonClicked:(NIFSearchBarCell*)searchBar;
- (void)searchBarTextDidBeginEditing:(NIFSearchBarCell*)searchBar;
- (void)searchBarTextDidEndEditing:(NIFSearchBarCell*)searchBar;
- (void)searchBar:(NIFSearchBarCell*)searchBar textDidChange:(NSString*)text;
@end

/** A replacement for UISearchBar to be used as a table view cell. */
@interface NIFSearchBarCell : UIView {
	UITextField* textField;
	
	UIButton* cancelButton;
	CGSize cancelButtonSize;
	
	BOOL cancelButtonShown;
	
	CGFloat textFieldCancelButtonPadding;
	
	UIEdgeInsets insets;
	
	id<NIFSearchBarCellDelegate> delegate;
	
	UIImageView* background;
}

@property (nonatomic, assign) id<NIFSearchBarCellDelegate> delegate;

- (void)setShowsCancelButton:(BOOL)shows animated:(BOOL)animated;

- (NSString*)text;
- (void)setText:(NSString*)text;
@property (nonatomic, copy) NSString* text;

- (UIColor*)tintColor;
- (void)setTintColor:(UIColor*)color;
@property (nonatomic, copy) UIColor* tintColor;

@end
