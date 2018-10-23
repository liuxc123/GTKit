//
//  UICollectionViewController+GTCCardReordering.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "UICollectionViewController+GTCCardReordering.h"

#import "GTInk.h"
#import "GTCCardCollectionCell.h"

@implementation UICollectionViewController (GTCCardReordering)


- (void)gtc_setupCardReordering {
    UILongPressGestureRecognizer *longGestureRecognizer =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];

    longGestureRecognizer.delegate = self;
    longGestureRecognizer.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:longGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    for (UIGestureRecognizer *gesture in self.collectionView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            gesture.cancelsTouchesInView = NO;
        }
    }
    return YES;
}
@end
