//
//  ButtonsTypicalUseSupplemental.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/24.
//

#import <UIKit/UIKit.h>

#import "GTColorScheme.h"
#import "GTTypographyScheme.h"

@interface ButtonsTypicalUseViewController : UIViewController

@property(nonatomic, strong) NSArray *buttons;
@property(nonatomic, strong) NSArray *labels;
@property(nonatomic, strong) GTCSemanticColorScheme *colorScheme;
@property(nonatomic, strong) GTCTypographyScheme *typographyScheme;

- (UILabel *)addLabelWithText:(NSString *)text;

@end

@interface ButtonsTypicalUseExampleViewController : ButtonsTypicalUseViewController

@end

@interface ButtonsShapesExampleViewController : ButtonsTypicalUseViewController

@end
