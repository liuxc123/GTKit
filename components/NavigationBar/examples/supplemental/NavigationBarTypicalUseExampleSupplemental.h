//
//  NavigationBarTypicalUseExampleSupplemental.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import <UIKit/UIKit.h>

#import "GTColorScheme.h"
#import "GTNavigationBar.h"
#import "GTTypographyScheme.h"

@class ExampleInstructionsViewNavigationBarTypicalUseExample;

@interface NavigationBarTypicalUseExample : UIViewController

@property(nonatomic) ExampleInstructionsViewNavigationBarTypicalUseExample *_Nullable exampleView;
@property(nonatomic) GTCNavigationBar *_Nullable navBar;
@property(nonatomic, strong, nullable) GTCSemanticColorScheme *colorScheme;

@end

@interface NavigationBarTypicalUseExample (Supplemental)

- (void)setupExampleViews;

@end

@interface NavigationBarWithBarItemsExample : NavigationBarTypicalUseExample
@end

@interface NavigationBarWithCustomFontExample : NavigationBarTypicalUseExample
@end

@interface NavigationBarIconsExample : UIViewController
@property(nonatomic, strong, nullable) GTCSemanticColorScheme *colorScheme;
@property(nonatomic, strong, nullable) GTCTypographyScheme *typographyScheme;
@end


