//
//  GTCSelfSizingStereoCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/9.
//

#import "GTCSelfSizingStereoCell.h"

#import <Foundation/Foundation.h>

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTInk.h"
#import "GTMath.h"
#import "GTTypography.h"

#import "private/GTCSelfSizingStereoCellLayout.h"

static const CGFloat kTitleColorOpacity = 0.87f;
static const CGFloat kDetailColorOpacity = 0.6f;

@interface GTCSelfSizingStereoCell ()

@property(nonatomic, strong) UIView *textContainer;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIImageView *leadingImageView;
@property(nonatomic, strong) UIImageView *trailingImageView;

@property(nonatomic, strong)
NSMutableDictionary<NSNumber *, GTCSelfSizingStereoCellLayout *> *cachedLayouts;

@end

@implementation GTCSelfSizingStereoCell

@synthesize gtc_adjustsFontForContentSizeCategory = _gtc_adjustsFontForContentSizeCategory;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonGTCSelfSizingStereoCellInit];
        return self;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCSelfSizingStereoCellInit];
        return self;
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTCSelfSizingStereoCellInit];
        return self;
    }
    return nil;
}

- (void)commonGTCSelfSizingStereoCellInit {
    [self createSubviews];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Setup

- (void)createSubviews {
    self.textContainer = [[UIView alloc] init];
    [self.contentView addSubview:self.textContainer];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = self.defaultTitleLabelFont;
    self.titleLabel.numberOfLines = 0;
    [self.textContainer addSubview:self.titleLabel];

    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = self.defaultDetailLabelFont;
    self.detailLabel.numberOfLines = 0;
    [self.textContainer addSubview:self.detailLabel];

    self.leadingImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.leadingImageView];

    self.trailingImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.trailingImageView];
}

#pragma mark UIView Overrides

- (void)layoutSubviews {
    [super layoutSubviews];

    GTCSelfSizingStereoCellLayout *layout = [self layoutForCellWidth:self.frame.size.width];
    self.textContainer.frame = layout.textContainerFrame;
    self.titleLabel.frame = layout.titleLabelFrame;
    self.detailLabel.frame = layout.detailLabelFrame;
    self.leadingImageView.frame = layout.leadingImageViewFrame;
    self.trailingImageView.frame = layout.trailingImageViewFrame;
    if (self.gtf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        self.leadingImageView.frame =
        GTFRectFlippedHorizontally(self.leadingImageView.frame, layout.cellWidth);
        self.trailingImageView.frame =
        GTFRectFlippedHorizontally(self.trailingImageView.frame, layout.cellWidth);
        self.textContainer.frame =
        GTFRectFlippedHorizontally(self.textContainer.frame, layout.cellWidth);
        self.titleLabel.frame =
        GTFRectFlippedHorizontally(self.titleLabel.frame, self.textContainer.frame.size.width);
        self.detailLabel.frame =
        GTFRectFlippedHorizontally(self.detailLabel.frame, self.textContainer.frame.size.width);
    } else {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setNeedsLayout {
    [self invalidateCachedLayouts];
    [super setNeedsLayout];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
    GTCSelfSizingStereoCellLayout *layout = [self layoutForCellWidth:targetSize.width];
    return CGSizeMake(targetSize.width, layout.calculatedHeight);
}

#pragma mark UICollectionViewCell Overrides

- (void)prepareForReuse {
    [super prepareForReuse];

    [self invalidateCachedLayouts];
    self.titleLabel.text = nil;
    self.titleLabel.font = self.defaultTitleLabelFont;
    self.detailLabel.text = nil;
    self.detailLabel.font = self.defaultDetailLabelFont;
    self.leadingImageView.image = nil;
    self.trailingImageView.image = nil;
}

#pragma mark Layout

- (GTCSelfSizingStereoCellLayout *)layoutForCellWidth:(CGFloat)cellWidth {
    CGFloat flooredCellWidth = GTCFloor(cellWidth);
    GTCSelfSizingStereoCellLayout *layout = self.cachedLayouts[@(flooredCellWidth)];
    if (!layout) {
        layout = [[GTCSelfSizingStereoCellLayout alloc] initWithLeadingImageView:self.leadingImageView
                                                               trailingImageView:self.trailingImageView
                                                                   textContainer:self.textContainer
                                                                      titleLabel:self.titleLabel
                                                                     detailLabel:self.detailLabel
                                                                       cellWidth:flooredCellWidth];
        self.cachedLayouts[@(flooredCellWidth)] = layout;
    }
    return layout;
}

- (void)invalidateCachedLayouts {
    [self.cachedLayouts removeAllObjects];
}

#pragma mark Dynamic Type

- (BOOL)gtc_adjustsFontForContentSizeCategory {
    return _gtc_adjustsFontForContentSizeCategory;
}

- (void)gtc_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtc_adjustsFontForContentSizeCategory = adjusts;

    if (_gtc_adjustsFontForContentSizeCategory) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentSizeCategoryDidChange:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIContentSizeCategoryDidChangeNotification
                                                      object:nil];
    }

    [self adjustFontsForContentSizeCategory];
}

// Handles UIContentSizeCategoryDidChangeNotifications
- (void)contentSizeCategoryDidChange:(__unused NSNotification *)notification {
    [self adjustFontsForContentSizeCategory];
}

- (void)adjustFontsForContentSizeCategory {
    UIFont *titleFont = self.titleLabel.font ?: self.defaultTitleLabelFont;
    UIFont *detailFont = self.detailLabel.font ?: self.defaultDetailLabelFont;
    if (_gtc_adjustsFontForContentSizeCategory) {
        titleFont =
        [titleFont gtc_fontSizedForMaterialTextStyle:GTCFontTextStyleTitle
                                scaledForDynamicType:_gtc_adjustsFontForContentSizeCategory];
        detailFont =
        [detailFont gtc_fontSizedForMaterialTextStyle:GTCFontTextStyleCaption
                                 scaledForDynamicType:_gtc_adjustsFontForContentSizeCategory];
    }
    self.titleLabel.font = titleFont;
    self.detailLabel.font = detailFont;
    [self setNeedsLayout];
}

#pragma mark Font Defaults

- (UIFont *)defaultTitleLabelFont {
    return [UIFont gtc_standardFontForMaterialTextStyle:GTCFontTextStyleTitle];
}

- (UIFont *)defaultDetailLabelFont {
    return [UIFont gtc_standardFontForMaterialTextStyle:GTCFontTextStyleCaption];
}

- (UIColor *)defaultTitleLabelTextColor {
    return [UIColor colorWithWhite:0 alpha:kTitleColorOpacity];
}

- (UIColor *)defaultDetailLabelTextColor {
    return [UIColor colorWithWhite:0 alpha:kDetailColorOpacity];
}

@end

