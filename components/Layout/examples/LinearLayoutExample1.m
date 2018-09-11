//
//  LinearLayoutExample1.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/7.
//

#import "GTLayout.h"

@interface LinearLayoutExample1 : UIViewController

@end


@implementation LinearLayoutExample1


- (void)viewDidLoad {
    [super viewDidLoad];

    GTCLinearLayout *rootLayout = [GTCLinearLayout linearLayoutWithOrientation:GTCOrientationVert];
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;

    rootLayout.insetsPaddingFromSafeArea = UIRectEdgeAll;

    rootLayout.insetLandscapeFringePadding = NO;

    UILabel *vertTitleLabel = [self createSectionLabel:NSLocalizedString(@"vertical(from top to bottom)",@"")];
    [vertTitleLabel sizeToFit];
    vertTitleLabel.topPos.equalTo(self.topLayoutGuide).offset(10);
    [rootLayout addSubview:vertTitleLabel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- Layout Construction

-(UILabel*)createSectionLabel:(NSString*)title
{
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.text = title;
    sectionLabel.font = [UIFont systemFontOfSize:17];
    [sectionLabel sizeToFit];             //sizeToFit函数的意思是让视图的尺寸刚好包裹其内容。注意sizeToFit方法必要在设置字体、文字后调用才正确。
    return sectionLabel;
}

-(UILabel*)createLabel:(NSString*)title backgroundColor:(UIColor*)color
{
    UILabel *v = [UILabel new];
    v.text = title;
    v.font = [UIFont systemFontOfSize:15];
    v.numberOfLines = 0;
    v.textAlignment = NSTextAlignmentCenter;
    v.adjustsFontSizeToFitWidth = YES;
    v.backgroundColor =  color;
    v.layer.shadowOffset = CGSizeMake(3, 3);
    v.layer.shadowColor = [UIColor redColor].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.3;

    return v;
}


#pragma mark - CatalogByConvention

+ (NSArray *)catalogBreadcrumbs {
    return @[ @"Layout", @"LinearLayout", @"LinearLayoutOCExample1"];
}

+ (BOOL)catalogIsPrimaryDemo {
    return NO;
}

+ (BOOL)catalogIsPresentable {
    return NO;
}

@end
