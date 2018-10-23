//
//  UIView+GTCFormAdditions.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <UIKit/UIKit.h>
#import "GTCFormDescriptorCell.h"

@interface UIView (GTCFormAdditions)

+ (id)autolayoutView;

- (NSLayoutConstraint *)layoutConstraintSameHeightOf:(UIView *)view;

- (UIView *)findFirstResponder;

- (UITableViewCell<GTCFormDescriptorCell> *)formDescriptorCell;

@end
