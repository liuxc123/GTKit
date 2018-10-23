//
//  GTCChipCollectionViewCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import <UIKit/UIKit.h>

@class GTCChipView;

/*
 A collection view cell containing a single GTCChipView.
 GTCChipCollectionViewCell manages the state of its chipView based on its own states.
 E.g: setting the state of the cell to selected will automatically apply to its chipView as well.
 */
@interface GTCChipCollectionViewCell : UICollectionViewCell

/*
 The chip view.

 The chip's bounds will be set to fill the collection view cell.
 */
@property(nonatomic, nonnull, strong, readonly) GTCChipView *chipView;

/*
 Animates the chip view every time the bounds change. Defaults to NO.

 Set this to YES to animate chip view when it resizes. If the chip view changes size upon selection
 this should be set to YES.
 */
@property(nonatomic, assign) BOOL alwaysAnimateResize;

/*
 Creates an GTCChipView for use in the collection view cell.

 Override this method to return a custom GTCChipView subclass.
 */
- (nonnull GTCChipView *)createChipView;

@end

