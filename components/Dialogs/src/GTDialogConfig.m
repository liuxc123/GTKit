//
//  GTDialogConfig.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/15.
//

#import "GTDialogConfig.h"



@implementation GTDialogConfig

@end




@interface GTDialogAction()

@property (nonatomic , copy ) void (^updateBlock)(GTDialogAction *);

@end

@implementation GTDialogAction

- (void)update {
    if (self.updateBlock) self.updateBlock(self);
}

@end
