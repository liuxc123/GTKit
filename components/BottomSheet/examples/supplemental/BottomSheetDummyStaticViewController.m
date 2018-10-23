//
//  BottomSheetDummyStaticViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/9/13.
//

#import "BottomSheetDummyStaticViewController.h"

@implementation BottomSheetDummyStaticViewController{
    // Add a view just beyond the bottom of our bounds so that bottom sheet bounce doesn't reveal the
    // background underneath.
    UIView *_overflowView;
}

- (instancetype)init {
    if (self = [super initWithNibName:nil bundle:nil]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];

    _overflowView = [[UIView alloc] initWithFrame:CGRectZero];
    _overflowView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_overflowView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGSize size = self.view.frame.size;
    _overflowView.frame = CGRectMake(0, size.height, size.width, 200);
}
@end
