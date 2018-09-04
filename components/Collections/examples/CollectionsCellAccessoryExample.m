//
//  CollectionsCellAccessoryExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/29.
//

#import "supplemental/CollectionsCellAccessoryExample.h"

static NSString *const kReusableIdentifierItem = @"itemCellIdentifier";

@implementation CollectionsCellAccessoryExample{
    NSArray *_accessoryTypes;
    NSMutableArray <NSArray *>*_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kReusableIdentifierItem];

    // Array of available accessory types.
    _accessoryTypes = @[
                        @(GTCCollectionViewCellAccessoryDisclosureIndicator),
                        @(GTCCollectionViewCellAccessoryCheckmark), @(GTCCollectionViewCellAccessoryDetailButton),
                        @(GTCCollectionViewCellAccessoryNone), @(GTCCollectionViewCellAccessoryNone)
                        ];

    // Populate content.
    _content = [NSMutableArray array];
    [_content addObject:@[ @"Enable Editing" ]];
    [_content addObject:@[
                          @"Disclosure Indicator", @"Checkmark", @"Detail Button", @"Custom Accessory View",
                          @"No Accessory View"
                          ]];

    // Customize collection view settings.
    self.styler.cellStyle = GTCCollectionViewCellStyleCard;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_content count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [_content[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GTCCollectionViewTextCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                              forIndexPath:indexPath];
    cell.textLabel.text = _content[indexPath.section][indexPath.item];
    // Add accessory views.
    if (indexPath.section == 0) {
        // Add switch as accessory view.
        UISwitch *editingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [editingSwitch addTarget:self
                          action:@selector(didSwitch:)
                forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = editingSwitch;
    } else {
        cell.accessoryType = [_accessoryTypes[indexPath.item] unsignedIntegerValue];
    }

      return cell;
}

#pragma mark - <GTCCollectionViewEditingDelegate>

- (BOOL)collectionViewAllowsEditing:(UICollectionView *)collectionView {
    return NO;
}

- (BOOL)collectionViewAllowsReordering:(UICollectionView *)collectionView {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canEditItemAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section != 0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section != 0);
}

#pragma mark - UIControlEvents

- (void)didSwitch:(id)sender {
    UISwitch *switchControl = sender;
    [self.editor setEditing:switchControl.isOn animated:YES];
}


#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Collections", @"Cell Accessory Example" ];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
