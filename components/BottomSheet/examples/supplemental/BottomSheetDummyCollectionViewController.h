//
//  BottomSheetDummyCollectionViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>

@interface BottomSheetDummyCollectionViewController : UICollectionViewController
- (instancetype)initWithNumItems:(NSInteger)numItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
NS_UNAVAILABLE;
@end
