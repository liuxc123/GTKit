//
//  GTCThumbView.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTShadowElevations.h"

@interface GTCThumbView : UIView

/**
 The elevation of the thumb view.

 Default is GTCShadowElevationNone (no shadow).
 */
@property(nonatomic, assign) GTCShadowElevation elevation;

/** The border width of the thumbview layer. */
@property(nonatomic, assign) CGFloat borderWidth;

/** The corner radius of the thumbview layer. */
@property(nonatomic, assign) CGFloat cornerRadius;

/** Set the @c icon shown on the thumb. */
- (void)setIcon:(nullable UIImage *)icon;

@end
