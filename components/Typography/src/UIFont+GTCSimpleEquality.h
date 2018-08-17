//
//  UIFont+GTCSimpleEquality.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <UIKit/UIKit.h>

#import "GTCFontTextStyle.h"

@interface UIFont (GTCSimpleEquality)

/*
 Checks simple characteristics: name, weight, pointsize, traits.

 While the actual implementation of UIFont's isEqual: is not known, it is believed that
 isSimplyEqual: is more 'shallow' than isEqual:.
 */

- (BOOL)gtc_isSimplyEqual:(UIFont*)font;

@end
