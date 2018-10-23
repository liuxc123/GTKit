//
//  GTCBottomNavigationItemView.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTCBottomNavigationBar.h"
#import "GTInk.h"

@interface GTCBottomNavigationItemView : UIView

@property(nonatomic, assign) BOOL titleBelowIcon;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, assign) GTCBottomNavigationBarTitleVisibility titleVisibility;
@property(nonatomic, strong) GTCInkView *inkView;

@property(nonatomic, copy) NSString *badgeValue;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIFont *itemTitleFont UI_APPEARANCE_SELECTOR;

@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *selectedImage;

@property(nonatomic, strong) UIColor *badgeColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *selectedItemTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *unselectedItemTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *selectedItemTitleColor;

@property(nonatomic, assign) UIEdgeInsets contentInsets;

@property(nonatomic, assign) CGFloat contentVerticalMargin;
@property(nonatomic, assign) CGFloat contentHorizontalMargin;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
