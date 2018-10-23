//
//  UICollectionViewController+GTCCardReordering.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewController (GTCCardReordering) <UIGestureRecognizerDelegate>

/**
 This method should be called when using a UICollectionViewController and want to have
 the reorder or drag and drop visuals. Please see
 https://developer.apple.com/documentation/uikit/uicollectionviewcontroller/1623979-installsstandardgestureforintera
 for more information. It will make sure that the underlying longPressGestureRecognizer
 doesn't cancel the ink tap visual causing the ink to disappear once the reorder begins.
 */
- (void)gtc_setupCardReordering;

@end
