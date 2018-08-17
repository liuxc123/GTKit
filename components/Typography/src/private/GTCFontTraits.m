//
//  GTCFontTraits.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCFontTraits.h"

static NSDictionary<NSString *, GTCFontTraits *> *_body1Traits;
static NSDictionary<NSString *, GTCFontTraits *> *_body2Traits;
static NSDictionary<NSString *, GTCFontTraits *> *_buttonTraits;
static NSDictionary<NSString *, GTCFontTraits *> *_captionTraits;
static NSDictionary<NSString *, GTCFontTraits *> *_display1Traits;
static NSDictionary<NSString *, GTCFontTraits *> *_display2Traits;
static NSDictionary<NSString *, GTCFontTraits *> *_display3Traits;
static NSDictionary<NSString *, GTCFontTraits *> *_display4Traits;
static NSDictionary<NSString *, GTCFontTraits *> *_headlineTraits;
static NSDictionary<NSString *, GTCFontTraits *> *_subheadlineTraits;
static NSDictionary<NSString *, GTCFontTraits *> *_titleTraits;

static NSDictionary<NSNumber *, NSDictionary *> *_styleTable;

@interface GTCFontTraits (MaterialTypographyPrivate)

+ (instancetype)traitsWithPointSize:(CGFloat)pointSize
                             weight:(CGFloat)weight
                            leading:(CGFloat)leading
                           tracking:(CGFloat)tracking;

- (instancetype)initWithPointSize:(CGFloat)pointSize
                           weight:(CGFloat)weight
                          leading:(CGFloat)leading
                         tracking:(CGFloat)tracking;

@end

@implementation GTCFontTraits

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
+ (void)initialize {
    _body1Traits = @{
                     UIContentSizeCategoryExtraSmall :
                         [GTCFontTraits traitsWithPointSize:11 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategorySmall :
                         [GTCFontTraits traitsWithPointSize:12 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryMedium :
                         [GTCFontTraits traitsWithPointSize:13 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryLarge :
                         [GTCFontTraits traitsWithPointSize:14 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryExtraLarge :
                         [GTCFontTraits traitsWithPointSize:16 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryExtraExtraLarge :
                         [GTCFontTraits traitsWithPointSize:18 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryExtraExtraExtraLarge :
                         [GTCFontTraits traitsWithPointSize:20 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityMedium :
                         [GTCFontTraits traitsWithPointSize:25 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityLarge :
                         [GTCFontTraits traitsWithPointSize:30 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraLarge :
                         [GTCFontTraits traitsWithPointSize:37 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraExtraLarge :
                         [GTCFontTraits traitsWithPointSize:44 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraExtraExtraLarge :
                         [GTCFontTraits traitsWithPointSize:52 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     };
    
    _body2Traits = @{
                     UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:11
                                                                                         weight:UIFontWeightMedium
                                                                                        leading:0.0
                                                                                       tracking:0.0],
                     UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:12
                                                                                    weight:UIFontWeightMedium
                                                                                   leading:0.0
                                                                                  tracking:0.0],
                     UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:13
                                                                                     weight:UIFontWeightMedium
                                                                                    leading:0.0
                                                                                   tracking:0.0],
                     UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:14
                                                                                    weight:UIFontWeightMedium
                                                                                   leading:0.0
                                                                                  tracking:0.0],
                     UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:16
                                                                                         weight:UIFontWeightMedium
                                                                                        leading:0.0
                                                                                       tracking:0.0],
                     UIContentSizeCategoryExtraExtraLarge :
                         [[GTCFontTraits alloc] initWithPointSize:18
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryExtraExtraExtraLarge :
                         [[GTCFontTraits alloc] initWithPointSize:20
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityMedium :
                         [[GTCFontTraits alloc] initWithPointSize:25
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityLarge :
                         [[GTCFontTraits alloc] initWithPointSize:30
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraLarge :
                         [[GTCFontTraits alloc] initWithPointSize:37
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraExtraLarge :
                         [[GTCFontTraits alloc] initWithPointSize:44
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraExtraExtraLarge :
                         [[GTCFontTraits alloc] initWithPointSize:52
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     };
    
    _buttonTraits = @{
                      UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:11
                                                                                          weight:UIFontWeightMedium
                                                                                         leading:0.0
                                                                                        tracking:0.0],
                      UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:12
                                                                                     weight:UIFontWeightMedium
                                                                                    leading:0.0
                                                                                   tracking:0.0],
                      UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:13
                                                                                      weight:UIFontWeightMedium
                                                                                     leading:0.0
                                                                                    tracking:0.0],
                      UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:14
                                                                                     weight:UIFontWeightMedium
                                                                                    leading:0.0
                                                                                   tracking:0.0],
                      UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:16
                                                                                          weight:UIFontWeightMedium
                                                                                         leading:0.0
                                                                                        tracking:0.0],
                      UIContentSizeCategoryExtraExtraLarge :
                          [[GTCFontTraits alloc] initWithPointSize:18
                                                            weight:UIFontWeightMedium
                                                           leading:0.0
                                                          tracking:0.0],
                      UIContentSizeCategoryExtraExtraExtraLarge :
                          [[GTCFontTraits alloc] initWithPointSize:20
                                                            weight:UIFontWeightMedium
                                                           leading:0.0
                                                          tracking:0.0],
                      };
    
    _captionTraits = @{
                       UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:11
                                                                                           weight:UIFontWeightRegular
                                                                                          leading:0.0
                                                                                         tracking:0.0],
                       UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:11
                                                                                      weight:UIFontWeightRegular
                                                                                     leading:0.0
                                                                                    tracking:0.0],
                       UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:11
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                       UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:12
                                                                                      weight:UIFontWeightRegular
                                                                                     leading:0.0
                                                                                    tracking:0.0],
                       UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:14
                                                                                           weight:UIFontWeightRegular
                                                                                          leading:0.0
                                                                                         tracking:0.0],
                       UIContentSizeCategoryExtraExtraLarge :
                           [[GTCFontTraits alloc] initWithPointSize:16
                                                             weight:UIFontWeightRegular
                                                            leading:0.0
                                                           tracking:0.0],
                       UIContentSizeCategoryExtraExtraExtraLarge :
                           [[GTCFontTraits alloc] initWithPointSize:18
                                                             weight:UIFontWeightRegular
                                                            leading:0.0
                                                           tracking:0.0],
                       };
    
    _display1Traits = @{
                        UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:28
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:30
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:32
                                                                                        weight:UIFontWeightRegular
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:34
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:36
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:38
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:40
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        };
    
    _display2Traits = @{
                        UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:39
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:41
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:43
                                                                                        weight:UIFontWeightRegular
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:45
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:47
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:49
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:51
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        };
    
    _display3Traits = @{
                        UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:50
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:52
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:54
                                                                                        weight:UIFontWeightRegular
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:56
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:58
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:60
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:62
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        };
    
    _display4Traits = @{
                        UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:100
                                                                                            weight:UIFontWeightLight
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:104
                                                                                       weight:UIFontWeightLight
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:108
                                                                                        weight:UIFontWeightLight
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:112
                                                                                       weight:UIFontWeightLight
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:116
                                                                                            weight:UIFontWeightLight
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:120
                                                              weight:UIFontWeightLight
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:124
                                                              weight:UIFontWeightLight
                                                             leading:0.0
                                                            tracking:0.0],
                        };
    
    _headlineTraits = @{
                        UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:21
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:22
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:23
                                                                                        weight:UIFontWeightRegular
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:24
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:26
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:28
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTCFontTraits alloc] initWithPointSize:30
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        };
    
    _subheadlineTraits = @{
                           UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:13
                                                                                               weight:UIFontWeightRegular
                                                                                              leading:0.0
                                                                                             tracking:0.0],
                           UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:14
                                                                                          weight:UIFontWeightRegular
                                                                                         leading:0.0
                                                                                        tracking:0.0],
                           UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:15
                                                                                           weight:UIFontWeightRegular
                                                                                          leading:0.0
                                                                                         tracking:0.0],
                           UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:16
                                                                                          weight:UIFontWeightRegular
                                                                                         leading:0.0
                                                                                        tracking:0.0],
                           UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:18
                                                                                               weight:UIFontWeightRegular
                                                                                              leading:0.0
                                                                                             tracking:0.0],
                           UIContentSizeCategoryExtraExtraLarge :
                               [[GTCFontTraits alloc] initWithPointSize:20
                                                                 weight:UIFontWeightRegular
                                                                leading:0.0
                                                               tracking:0.0],
                           UIContentSizeCategoryExtraExtraExtraLarge :
                               [[GTCFontTraits alloc] initWithPointSize:22
                                                                 weight:UIFontWeightRegular
                                                                leading:0.0
                                                               tracking:0.0],
                           };
    
    _titleTraits = @{
                     UIContentSizeCategoryExtraSmall : [[GTCFontTraits alloc] initWithPointSize:17
                                                                                         weight:UIFontWeightMedium
                                                                                        leading:0.0
                                                                                       tracking:0.0],
                     UIContentSizeCategorySmall : [[GTCFontTraits alloc] initWithPointSize:18
                                                                                    weight:UIFontWeightMedium
                                                                                   leading:0.0
                                                                                  tracking:0.0],
                     UIContentSizeCategoryMedium : [[GTCFontTraits alloc] initWithPointSize:19
                                                                                     weight:UIFontWeightMedium
                                                                                    leading:0.0
                                                                                   tracking:0.0],
                     UIContentSizeCategoryLarge : [[GTCFontTraits alloc] initWithPointSize:20
                                                                                    weight:UIFontWeightMedium
                                                                                   leading:0.0
                                                                                  tracking:0.0],
                     UIContentSizeCategoryExtraLarge : [[GTCFontTraits alloc] initWithPointSize:22
                                                                                         weight:UIFontWeightMedium
                                                                                        leading:0.0
                                                                                       tracking:0.0],
                     UIContentSizeCategoryExtraExtraLarge :
                         [[GTCFontTraits alloc] initWithPointSize:24
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryExtraExtraExtraLarge :
                         [[GTCFontTraits alloc] initWithPointSize:26
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     };
    
    _styleTable = @{
                    @(GTCFontTextStyleBody1) : _body1Traits,
                    @(GTCFontTextStyleBody2) : _body2Traits,
                    @(GTCFontTextStyleButton) : _buttonTraits,
                    @(GTCFontTextStyleCaption) : _captionTraits,
                    @(GTCFontTextStyleDisplay1) : _display1Traits,
                    @(GTCFontTextStyleDisplay2) : _display2Traits,
                    @(GTCFontTextStyleDisplay3) : _display3Traits,
                    @(GTCFontTextStyleDisplay4) : _display4Traits,
                    @(GTCFontTextStyleHeadline) : _headlineTraits,
                    @(GTCFontTextStyleSubheadline) : _subheadlineTraits,
                    @(GTCFontTextStyleTitle) : _titleTraits
                    };
}
#pragma clang diagnostic pop

+ (instancetype)traitsWithPointSize:(CGFloat)pointSize
                             weight:(CGFloat)weight
                            leading:(CGFloat)leading
                           tracking:(CGFloat)tracking {
    return [[GTCFontTraits alloc] initWithPointSize:pointSize
                                             weight:weight
                                            leading:leading
                                           tracking:tracking];
}

- (instancetype)initWithPointSize:(CGFloat)pointSize
                           weight:(CGFloat)weight
                          leading:(CGFloat)leading
                         tracking:(CGFloat)tracking {
    self = [super init];
    if (self) {
        _pointSize = pointSize;
        _weight = weight;
        _leading = leading;
        _tracking = tracking;
    }
    
    return self;
}

+ (GTCFontTraits *)traitsForTextStyle:(GTCFontTextStyle)style
                         sizeCategory:(NSString *)sizeCategory {
    NSDictionary *traitsTable = _styleTable[@(style)];
    NSCAssert(traitsTable, @"traitsTable cannot be nil. Is style valid?");
    
    GTCFontTraits *traits;
    if (traitsTable) {
        if (sizeCategory) {
            traits = traitsTable[sizeCategory];
        }
        
        // If you have queried the table for a sizeCategory that doesn't exist, we will return the
        // traits for XXXL.  This handles the case where the values are requested for one of the
        // accessibility size categories beyond XXXL such as
        // UIContentSizeCategoryAccessibilityExtraLarge.  Accessbility size categories are only
        // defined for the Body Font Style.
        if (traits == nil) {
            traits = traitsTable[UIContentSizeCategoryExtraExtraExtraLarge];
        }
    }
    
    return traits;
}

@end

