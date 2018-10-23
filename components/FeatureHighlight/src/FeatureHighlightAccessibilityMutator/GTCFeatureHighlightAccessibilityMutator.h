//
//  GTCFeatureHighlightAccessibilityMutator.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/17.
//

@class GTCFeatureHighlightViewController;

#import <GTFTextAccessibility/GTFTextAccessibility.h>
#import <UIKit/UIKit.h>

/**
 A Mutator that will change an instance of GTCFeatureHighlightViewController to have a high enough
 contrast text between its background.
 Calling this mutator can overwrite UIApperance values.
 */
@interface GTCFeatureHighlightAccessibilityMutator : NSObject

/**
 This method will change the title and body color of the feature highlight to ensure a high
 accessiblity contrast with its background if needed.
 */
+ (void)mutate:(GTCFeatureHighlightViewController *)featureHighlightViewController;

@end
