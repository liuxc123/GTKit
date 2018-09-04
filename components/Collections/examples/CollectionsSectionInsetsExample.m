//
//  CollectionsSectionInsetsExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "supplemental/CollectionsSectionInsetsExampleSupplemental.h"

@implementation CollectionsSectionInsetsExample

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self collectionsSectionInsetsExampleCommonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self collectionsSectionInsetsExampleCommonInit];
    }
    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        [self collectionsSectionInsetsExampleCommonInit];
    }
    return self;
}

- (void)collectionsSectionInsetsExampleCommonInit {
    _content = [NSMutableArray array];
    _sectionUsesCustomInsets = [NSMutableDictionary dictionaryWithCapacity:kSectionCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                              forIndexPath:indexPath];
    cell.textLabel.text = self.content[indexPath.section][indexPath.item];
    cell.accessibilityIdentifier =
    [NSString stringWithFormat:@"%ld.%ld", (long)indexPath.section, (long)indexPath.row];
    if (indexPath.row == 0) {
        UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchControl setOn:[self.sectionUsesCustomInsets[@(indexPath.section)] boolValue]];
        [switchControl addTarget:self
                          action:@selector(didSet:)
                forControlEvents:UIControlEventValueChanged];
        switchControl.tag = indexPath.section;

        cell.accessoryView = switchControl;
    }

    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets insets = [super collectionView:collectionView
                                         layout:collectionViewLayout
                         insetForSectionAtIndex:section];
    if ([self.sectionUsesCustomInsets[@(section)] boolValue]) {
        insets.left = MIN(40, 8 * section);
        insets.right = insets.left;
    }
    return insets;
}

#pragma mark - UIControlEventHandlers

- (void)didSet:(UISwitch *)sender {
    NSUInteger section = sender.tag;
    self.sectionUsesCustomInsets[@(section)] = @(sender.isOn);
    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end
