//
//  CollectionCellsTextExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "GTTypography.h"
#import "supplemental/CollectionCellsTextExample.h"

static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";
static NSString *const kExampleDetailText =
@"Pellentesque non quam ornare, porta urna sed, malesuada felis. Praesent at gravida felis, "
"non facilisis enim. Proin dapibus laoreet lorem, in viverra leo dapibus a.";


@implementation CollectionCellsTextExample{
    NSMutableArray *_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];


    // Populate content with array of text, details text, and number of lines.
    _content = [NSMutableArray array];

    NSDictionary *alignmentValues = @{
                                      @"Left" : @(NSTextAlignmentLeft),
                                      @"Right" : @(NSTextAlignmentRight),
                                      @"Center" : @(NSTextAlignmentCenter),
                                      @"Just." : @(NSTextAlignmentJustified),
                                      @"Natural" : @(NSTextAlignmentNatural)
                                      };

    for (NSString *alignmentKey in alignmentValues) {
        [_content addObject:@[
                              [NSString stringWithFormat:@"(%@) Single line text", alignmentKey],
                              alignmentValues[alignmentKey], @"", alignmentValues[alignmentKey],
                              @(GTCCellDefaultOneLineHeight)
                              ]];
        [_content addObject:@[
                              @"", alignmentValues[alignmentKey],
                              [NSString stringWithFormat:@"(%@) Single line detail text", alignmentKey],
                              alignmentValues[alignmentKey], @(GTCCellDefaultOneLineHeight)
                              ]];
        [_content addObject:@[
                              [NSString stringWithFormat:@"(%@) Two line text", alignmentKey],
                              alignmentValues[alignmentKey],
                              [NSString stringWithFormat:@"(%@) Here is the detail text", alignmentKey],
                              alignmentValues[alignmentKey], @(GTCCellDefaultTwoLineHeight)
                              ]];
        [_content addObject:@[
                              [NSString stringWithFormat:@"(%@) Two line text (truncated)", alignmentKey],
                              alignmentValues[alignmentKey],
                              [NSString stringWithFormat:@"(%@) %@", alignmentKey, kExampleDetailText],
                              alignmentValues[alignmentKey], @(GTCCellDefaultTwoLineHeight)
                              ]];
        [_content addObject:@[
                              [NSString stringWithFormat:@"(%@) Three line text (wrapped)", alignmentKey],
                              alignmentValues[alignmentKey],
                              [NSString stringWithFormat:@"(%@) %@", alignmentKey, kExampleDetailText],
                              alignmentValues[alignmentKey], @(GTCCellDefaultThreeLineHeight)
                              ]];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [_content count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                              forIndexPath:indexPath];
    cell.textLabel.text = _content[indexPath.item][0];
    cell.textLabel.textAlignment = [_content[indexPath.item][1] integerValue];
    cell.detailTextLabel.text = _content[indexPath.item][2];
    cell.detailTextLabel.textAlignment = [_content[indexPath.item][3] integerValue];

    if (indexPath.item % 5 == 4) {
        cell.detailTextLabel.numberOfLines = 2;
    }
    return cell;
}

#pragma mark - <GTCCollectionViewStylingDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView
    cellHeightAtIndexPath:(NSIndexPath *)indexPath {
    return [_content[indexPath.item][4] floatValue];
}

#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collection Cells", @"Cell Text Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return YES;
}

+ (NSString *)catalogDescription {
    return @"Material Collection Cells enables a native collection view cell to have Material "
    "design layout and styling. It also provides editing and extensive customization "
    "capabilities.";
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
