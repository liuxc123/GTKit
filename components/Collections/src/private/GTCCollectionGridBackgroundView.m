//
//  GTCCollectionGridBackgroundView.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "GTCCollectionGridBackgroundView.h"

#import "GTCollectionLayoutAttributes.h"

@implementation GTCCollectionGridBackgroundView{
    UIImageView *_backgroundImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCCollectionGridBackgroundViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTCCollectionGridBackgroundViewInit];
    }
    return self;
}

- (void)commonGTCCollectionGridBackgroundViewInit {
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_backgroundImageView];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    NSAssert([layoutAttributes isKindOfClass:[GTCCollectionViewLayoutAttributes class]],
             @"LayoutAttributes must be a subclass of GTCCollectionViewLayoutAttributes.");
    GTCCollectionViewLayoutAttributes *attr = (GTCCollectionViewLayoutAttributes *)layoutAttributes;
    _backgroundImageView.image = attr.backgroundImage;
}


@end
