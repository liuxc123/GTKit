//
//  BottomSheetPresenterViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import <UIKit/UIKit.h>

#import "GTColorScheme.h"
#import "GTTypographyScheme.h"

@interface BottomSheetPresenterViewController : UIViewController

@property(nonatomic, strong) GTCSemanticColorScheme *colorScheme;
@property(nonatomic, strong) GTCTypographyScheme *typographyScheme;

- (void)presentBottomSheet;

@end
