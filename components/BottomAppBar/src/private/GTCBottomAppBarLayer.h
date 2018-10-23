//
//  GTCBottomAppBarLayer.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

#import "GTCBottomAppBarView.h"

@interface GTCBottomAppBarLayer : CAShapeLayer

- (CGPathRef)pathFromRect:(CGRect)rect
           floatingButton:(GTCFloatingButton *)floatingButton
       navigationBarFrame:(CGRect)navigationBarFrame
                shouldCut:(BOOL)shouldCut;

@end
