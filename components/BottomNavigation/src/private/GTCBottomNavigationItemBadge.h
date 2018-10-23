//
//  GTCBottomNavigationItemBadge.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GTCBottomNavigationItemBadge : UIView

@property(nonatomic, assign) CGFloat badgeCircleWidth;
@property(nonatomic, assign) CGFloat badgeCircleHeight;
@property(nonatomic, assign) CGFloat xPadding;
@property(nonatomic, assign) CGFloat yPadding;

@property(nonatomic, copy) NSString *badgeValue;
@property(nonatomic, strong) UIColor *badgeColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong, readonly) UILabel *badgeValueLabel;

@end
