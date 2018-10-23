//
//  GTCShapeSchemeExampleViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/8.
//

#import "GTCShapeSchemeExampleViewController.h"

#import "../../../BottomSheet/examples/supplemental/BottomSheetDummyCollectionViewController.h"
#import "supplemental/GTCBottomSheetControllerShapeThemerDefaultMapping.h"
#import "supplemental/GTCChipViewShapeThemerDefaultMapping.h"
#import "supplemental/GTCFloatingButtonShapeThemerDefaultMapping.h"

#import "GTAppBar+ColorThemer.h"
#import "GTAppBar+TypographyThemer.h"
#import "GTAppBar.h"
#import "GTBottomSheet+ShapeThemer.h"
#import "GTBottomSheet.h"
#import "GTButtons+ButtonThemer.h"
#import "GTButtons+ShapeThemer.h"
#import "GTButtons.h"
#import "GTCards+CardThemer.h"
#import "GTCards+ShapeThemer.h"
#import "GTCards.h"
#import "GTChips+ChipThemer.h"
#import "GTChips+ShapeThemer.h"
#import "GTChips.h"
#import "GTColorScheme.h"
#import "GTShapeLibrary.h"
#import "GTShapeScheme.h"
#import "GTTypographyScheme.h"

@interface GTCShapeSchemeExampleViewController ()
@property(strong, nonatomic) GTCSemanticColorScheme *colorScheme;
@property(strong, nonatomic) GTCShapeScheme *shapeScheme;
@property(strong, nonatomic) GTCTypographyScheme *typographyScheme;

@property(weak, nonatomic) IBOutlet GTCShapedView *smallComponentShape;
@property(weak, nonatomic) IBOutlet GTCShapedView *mediumComponentShape;
@property(weak, nonatomic) IBOutlet GTCShapedView *largeComponentShape;
@property(weak, nonatomic) IBOutlet UISegmentedControl *smallComponentType;
@property(weak, nonatomic) IBOutlet UISegmentedControl *mediumComponentType;
@property(weak, nonatomic) IBOutlet UISegmentedControl *largeComponentType;
@property(weak, nonatomic) IBOutlet UISlider *smallComponentValue;
@property(weak, nonatomic) IBOutlet UISlider *mediumComponentValue;
@property(weak, nonatomic) IBOutlet UISlider *largeComponentValue;
@property(weak, nonatomic) IBOutlet UISegmentedControl *includeBaselineOverridesToggle;
@property(weak, nonatomic) IBOutlet UIView *componentContentView;

@property(strong, nonatomic) GTCButton *containedButton;
@property(strong, nonatomic) GTCButton *outlinedButton;
@property(strong, nonatomic) GTCFloatingButton *floatingButton;
@property(strong, nonatomic) GTCChipView *chipView;
@property(strong, nonatomic) GTCCard *card;
@property(strong, nonatomic) GTCButton *presentBottomSheetButton;
@property(strong, nonatomic) GTCBottomSheetController *bottomSheetController;
@end

@implementation GTCShapeSchemeExampleViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonShapeSchemeExampleInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonShapeSchemeExampleInit];
    }
    return self;
}

- (void)commonShapeSchemeExampleInit {
    _colorScheme = [[GTCSemanticColorScheme alloc] init];
    _shapeScheme = [[GTCShapeScheme alloc] init];
    _typographyScheme = [[GTCTypographyScheme alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _smallComponentShape.shapeGenerator = [[GTCRectangleShapeGenerator alloc] init];
    _mediumComponentShape.shapeGenerator = [[GTCRectangleShapeGenerator alloc] init];
    _largeComponentShape.shapeGenerator = [[GTCRectangleShapeGenerator alloc] init];

    [self applySchemeColors];
    [self initializeComponentry];
}

- (void)initializeComponentry {
    GTCButtonScheme *buttonScheme = [[GTCButtonScheme alloc] init];
    buttonScheme.colorScheme = self.colorScheme;
    buttonScheme.shapeScheme = self.shapeScheme;
    buttonScheme.typographyScheme = self.typographyScheme;

    self.containedButton = [[GTCButton alloc] init];
    [self.containedButton setTitle:@"Button" forState:UIControlStateNormal];
    [GTCContainedButtonThemer applyScheme:buttonScheme toButton:self.containedButton];
    self.containedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.componentContentView addSubview:self.containedButton];

    self.floatingButton = [[GTCFloatingButton alloc] init];
    UIImage *plusImage =
    [[UIImage imageNamed:@"Plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.floatingButton setImage:plusImage forState:UIControlStateNormal];
    [GTCFloatingActionButtonThemer applyScheme:buttonScheme toButton:self.floatingButton];
    [self.floatingButton sizeToFit];
    self.floatingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.componentContentView addSubview:self.floatingButton];

    GTCChipViewScheme *chipViewScheme = [[GTCChipViewScheme alloc] init];
    chipViewScheme.colorScheme = self.colorScheme;
    chipViewScheme.shapeScheme = self.shapeScheme;
    chipViewScheme.typographyScheme = self.typographyScheme;

    self.chipView = [[GTCChipView alloc] init];
    self.chipView.titleLabel.text = @"GTKit";
    self.chipView.imageView.image = [self faceImage];
    self.chipView.accessoryView = [self deleteButton];
    self.chipView.minimumSize = CGSizeMake(140, 33);
    self.chipView.translatesAutoresizingMaskIntoConstraints = NO;
    [GTCChipViewThemer applyScheme:chipViewScheme toChipView:self.chipView];
    [self.componentContentView addSubview:self.chipView];

    GTCCardScheme *cardScheme = [[GTCCardScheme alloc] init];
    cardScheme.colorScheme = self.colorScheme;
    cardScheme.shapeScheme = self.shapeScheme;

    self.card = [[GTCCard alloc] init];
    self.card.translatesAutoresizingMaskIntoConstraints = NO;
    [GTCCardThemer applyScheme:cardScheme toCard:self.card];
    self.card.backgroundColor = _colorScheme.primaryColor;
    [self.componentContentView addSubview:self.card];

    NSArray<NSLayoutConstraint *> *cardConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[card]-|"
                                            options:0
                                            metrics:nil
                                              views:@{@"card" : self.card}];
    [self.view addConstraints:cardConstraints];

    self.presentBottomSheetButton = [[GTCButton alloc] init];
    [self.presentBottomSheetButton setTitle:@"Present Bottom Sheet" forState:UIControlStateNormal];
    [GTCOutlinedButtonThemer applyScheme:buttonScheme toButton:self.presentBottomSheetButton];
    self.presentBottomSheetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.componentContentView addSubview:self.presentBottomSheetButton];
    [self.presentBottomSheetButton addTarget:self
                                      action:@selector(presentBottomSheet)
                            forControlEvents:UIControlEventTouchUpInside];

    NSArray<NSLayoutConstraint *> *bottomSheetConstraints = [NSLayoutConstraint
                                                             constraintsWithVisualFormat:@"H:|-[presentBottomSheetButton]-|"
                                                             options:0
                                                             metrics:nil
                                                             views:@{@"presentBottomSheetButton" : self.presentBottomSheetButton}];
    [self.view addConstraints:bottomSheetConstraints];

    NSArray<NSLayoutConstraint *> *componentConstraints = [NSLayoutConstraint
                                                           constraintsWithVisualFormat:@"V:|-(30)-[containedButton]-(20)-[floatingButton]-(20)-["
                                                           @"chipView]-(20)-[card(80)]-(20)-[presentBottomSheetButton]"
                                                           options:NSLayoutFormatAlignAllCenterX
                                                           metrics:nil
                                                           views:@{
                                                                   @"containedButton" : self.containedButton,
                                                                   @"floatingButton" : self.floatingButton,
                                                                   @"chipView" : self.chipView,
                                                                   @"card" : self.card,
                                                                   @"presentBottomSheetButton" : self.presentBottomSheetButton
                                                                   }];
    [self.view addConstraints:componentConstraints];
}

- (void)presentBottomSheet {
    BottomSheetDummyCollectionViewController *viewController =
    [[BottomSheetDummyCollectionViewController alloc] initWithNumItems:102];
    viewController.title = @"Shaped bottom sheet example";

    GTCAppBarContainerViewController *container =
    [[GTCAppBarContainerViewController alloc] initWithContentViewController:viewController];
    container.preferredContentSize = CGSizeMake(500, 200);
    container.appBarViewController.headerView.trackingScrollView = viewController.collectionView;
    container.topLayoutGuideAdjustmentEnabled = YES;

    [GTCAppBarColorThemer applyColorScheme:self.colorScheme
                    toAppBarViewController:container.appBarViewController];
    [GTCAppBarTypographyThemer applyTypographyScheme:self.typographyScheme
                              toAppBarViewController:container.appBarViewController];

    self.bottomSheetController =
    [[GTCBottomSheetController alloc] initWithContentViewController:container];
    self.bottomSheetController.trackingScrollView = viewController.collectionView;
    [self updateComponentShapesWithBaselineOverrides:self.includeBaselineOverridesToggle
     .selectedSegmentIndex == 0];
    [self presentViewController:self.bottomSheetController animated:YES completion:nil];
}

- (UIImage *)faceImage {
    NSBundle *bundle = [NSBundle bundleForClass:[GTCShapeSchemeExampleViewController class]];
    UIImage *image = [UIImage imageNamed:@"ic_mask"
                                inBundle:bundle
           compatibleWithTraitCollection:nil];
    return image;
}

- (UIButton *)deleteButton {
    NSBundle *bundle = [NSBundle bundleForClass:[GTCShapeSchemeExampleViewController class]];
    UIImage *image = [UIImage imageNamed:@"ic_cancel"
                                inBundle:bundle
           compatibleWithTraitCollection:nil];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.tintColor = [UIColor colorWithWhite:0 alpha:0.7f];
    [button setImage:image forState:UIControlStateNormal];

    return button;
}

- (void)applySchemeColors {
    _smallComponentShape.backgroundColor = _colorScheme.primaryColor;
    _mediumComponentShape.backgroundColor = _colorScheme.primaryColor;
    _largeComponentShape.backgroundColor = _colorScheme.primaryColor;

    [_smallComponentType setTintColor:_colorScheme.primaryColor];
    [_mediumComponentType setTintColor:_colorScheme.primaryColor];
    [_largeComponentType setTintColor:_colorScheme.primaryColor];
    [_includeBaselineOverridesToggle setTintColor:_colorScheme.primaryColor];
}

- (void)updateShapeSchemeValues {
    GTCRectangleShapeGenerator *smallRect =
    (GTCRectangleShapeGenerator *)_smallComponentShape.shapeGenerator;
    smallRect.topLeftCorner = _shapeScheme.smallComponentShape.topLeftCorner;
    smallRect.topRightCorner = _shapeScheme.smallComponentShape.topRightCorner;
    smallRect.bottomLeftCorner = _shapeScheme.smallComponentShape.bottomLeftCorner;
    smallRect.bottomRightCorner = _shapeScheme.smallComponentShape.bottomRightCorner;
    _smallComponentShape.shapeGenerator = smallRect;

    GTCRectangleShapeGenerator *mediumRect =
    (GTCRectangleShapeGenerator *)_mediumComponentShape.shapeGenerator;
    mediumRect.topLeftCorner = _shapeScheme.mediumComponentShape.topLeftCorner;
    mediumRect.topRightCorner = _shapeScheme.mediumComponentShape.topRightCorner;
    mediumRect.bottomLeftCorner = _shapeScheme.mediumComponentShape.bottomLeftCorner;
    mediumRect.bottomRightCorner = _shapeScheme.mediumComponentShape.bottomRightCorner;
    _mediumComponentShape.shapeGenerator = mediumRect;

    GTCRectangleShapeGenerator *largeRect =
    (GTCRectangleShapeGenerator *)_largeComponentShape.shapeGenerator;
    largeRect.topLeftCorner = _shapeScheme.largeComponentShape.topLeftCorner;
    largeRect.topRightCorner = _shapeScheme.largeComponentShape.topRightCorner;
    largeRect.bottomLeftCorner = _shapeScheme.largeComponentShape.bottomLeftCorner;
    largeRect.bottomRightCorner = _shapeScheme.largeComponentShape.bottomRightCorner;
    _largeComponentShape.shapeGenerator = largeRect;

    [self updateComponentShapes];
}

- (void)updateComponentShapes {
    [GTCButtonShapeThemer applyShapeScheme:_shapeScheme toButton:self.containedButton];
    [GTCButtonShapeThemer applyShapeScheme:_shapeScheme toButton:self.outlinedButton];
    [GTCCardsShapeThemer applyShapeScheme:_shapeScheme toCard:self.card];
    [GTCButtonShapeThemer applyShapeScheme:_shapeScheme toButton:self.presentBottomSheetButton];
    [self updateComponentShapesWithBaselineOverrides:self.includeBaselineOverridesToggle
     .selectedSegmentIndex == 0];
}

- (GTCShapeCategory *)changedCategoryFromType:(UISegmentedControl *)sender
                                     andValue:(UISlider *)slider {
    GTCShapeCategory *changedCategory;
    if ([[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] isEqualToString:@"Cut"]) {
        // Cut Corner
        changedCategory = [[GTCShapeCategory alloc] initCornersWithFamily:GTCShapeCornerFamilyCut
                                                                  andSize:slider.value];
    } else {
        // Rounded Corner
        changedCategory = [[GTCShapeCategory alloc] initCornersWithFamily:GTCShapeCornerFamilyRounded
                                                                  andSize:slider.value];
    }
    return changedCategory;
}

- (IBAction)smallComponentTypeChanged:(UISegmentedControl *)sender {
    _shapeScheme.smallComponentShape = [self changedCategoryFromType:sender
                                                            andValue:_smallComponentValue];
    [self updateShapeSchemeValues];
}

- (IBAction)smallComponentValueChanged:(UISlider *)sender {
    _shapeScheme.smallComponentShape = [self changedCategoryFromType:_smallComponentType
                                                            andValue:sender];

    [self updateShapeSchemeValues];
}

- (IBAction)mediumComponentTypeChanged:(UISegmentedControl *)sender {
    _shapeScheme.mediumComponentShape = [self changedCategoryFromType:sender
                                                             andValue:_mediumComponentValue];
    [self updateShapeSchemeValues];
}

- (IBAction)mediumComponentValueChanged:(UISlider *)sender {
    _shapeScheme.mediumComponentShape = [self changedCategoryFromType:_mediumComponentType
                                                             andValue:sender];

    [self updateShapeSchemeValues];
}

- (IBAction)largeComponentTypeChanged:(UISegmentedControl *)sender {
    _shapeScheme.largeComponentShape = [self changedCategoryFromType:sender
                                                            andValue:_largeComponentValue];
    [self updateShapeSchemeValues];
}

- (IBAction)largeComponentValueChanged:(UISlider *)sender {
    _shapeScheme.largeComponentShape = [self changedCategoryFromType:_largeComponentType
                                                            andValue:sender];

    [self updateShapeSchemeValues];
}

- (IBAction)baselineOverrideValueChanged:(UISegmentedControl *)sender {
    [self updateComponentShapesWithBaselineOverrides:sender.selectedSegmentIndex == 0];
}

- (void)updateComponentShapesWithBaselineOverrides:(BOOL)baselineOverrides {
    if (!baselineOverrides) {
        // We don't want baseline overrides.
        [GTCBottomSheetControllerShapeThemerDefaultMapping applyShapeScheme:_shapeScheme
                                                    toBottomSheetController:self.bottomSheetController];
        [GTCChipViewShapeThemerDefaultMapping applyShapeScheme:_shapeScheme toChipView:self.chipView];
        [GTCFloatingButtonShapeThemerDefaultMapping applyShapeScheme:_shapeScheme
                                                            toButton:self.floatingButton];
    } else {
        // We do want baseline overrides.
        [GTCBottomSheetControllerShapeThemer applyShapeScheme:_shapeScheme
                                      toBottomSheetController:self.bottomSheetController];
        [GTCChipViewShapeThemer applyShapeScheme:_shapeScheme toChipView:self.chipView];
        [GTCFloatingButtonShapeThemer applyShapeScheme:_shapeScheme toButton:self.floatingButton];
    }
}

@end

#pragma mark - Catalog by convention
@implementation GTCShapeSchemeExampleViewController (CatlogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
             @"breadcrumbs" : @[ @"Shape", @"ShapeScheme" ],
             @"description" :
                 @"The Shape scheme and theming allows components to be shaped on a theme level",
             @"primaryDemo" : @YES,
             @"presentable" : @NO,
             @"storyboardName" : @"GTCShapeSchemeExampleViewController",
             };
}

@end
