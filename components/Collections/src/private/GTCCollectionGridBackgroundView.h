//
//  GTCCollectionGridBackgroundView.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import <UIKit/UIKit.h>

/**
 The GTCCollectionGridBackgroundView class provides an implementation of UICollectionReusableView
 that displays a background view under cells at each section of a collection view in grid layout.

 This will only happen for a grid layout when it is either A) grouped-style or B) card-style with
 zero padding. When this happens, the background for the section cells will not be drawn, and
 instead this view will extend to the bounds of the sum of its respective section item frames.
 */
@interface GTCCollectionGridBackgroundView : UICollectionReusableView

@end
