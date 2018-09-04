//
//  CollectionsEditingManyCellsExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/30.
//

#import "supplemental/CollectionsEditingManyCellsExampleSupplemental.h"

static const NSInteger kSectionCount = 25;
static const NSInteger kSectionItemCount = 50;

@implementation CollectionsEditingManyCellsExample

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];


    // Add button to toggle edit mode.
    [self updatedRightBarButtonItem:NO];

    // Register cell class.
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forCellWithReuseIdentifier:kCollectionsEditingManyCellsCellIdentifierItem];
    // Optional
    // Register section header class
    [self.collectionView registerClass:[GTCCollectionViewTextCell class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kCollectionsEditingManyCellsHeaderReuseIdentifier];

    // Populate content.
    self.content = [NSMutableArray array];
    for (NSInteger i = 0; i < kSectionCount; i++) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSInteger j = 0; j < kSectionItemCount; j++) {
            NSString *itemString =
            [NSString stringWithFormat:@"Section-%02ld Item-%02ld", (long)i, (long)j];
            [items addObject:itemString];
        }
        [self.content addObject:items];
    }

    // Customize collection view settings.
    self.styler.cellStyle = GTCCollectionViewCellStyleCard;
}

- (void)updatedRightBarButtonItem:(BOOL)isEditing {
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:isEditing ? @"Cancel" : @"Edit"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(toggleEditMode:)];
}

- (void)toggleEditMode:(id)sender {
    BOOL isEditing = self.editor.isEditing;
    [self updatedRightBarButtonItem:!isEditing];
    [self.editor setEditing:!isEditing animated:YES];
}
@end
