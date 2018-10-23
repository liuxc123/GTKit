//
//  GTCSelfSizingStereoCellLayout.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTCSelfSizingStereoCellLayout : NSObject

@property(nonatomic, assign, readonly) CGFloat cellWidth;
@property(nonatomic, assign, readonly) CGFloat calculatedHeight;
@property(nonatomic, assign, readonly) CGRect textContainerFrame;
@property(nonatomic, assign, readonly) CGRect titleLabelFrame;
@property(nonatomic, assign, readonly) CGRect detailLabelFrame;
@property(nonatomic, assign, readonly) CGRect leadingImageViewFrame;
@property(nonatomic, assign, readonly) CGRect trailingImageViewFrame;

- (instancetype)initWithLeadingImageView:(UIImageView *)leadingImageView
                       trailingImageView:(UIImageView *)trailingImageView
                           textContainer:(UIView *)textContainer
                              titleLabel:(UILabel *)titleLabel
                             detailLabel:(UILabel *)detailLabel
                               cellWidth:(CGFloat)cellWidth;

@end
