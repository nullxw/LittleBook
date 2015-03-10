//
//  HPTabBarChildController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPTabBarChildController.h"
#import "HPTarBarController.h"
#import "HPTabBar.h"

@interface HPTabBarChildController () <HPTabBarProtocol>

@end

@implementation HPTabBarChildController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = TRUE;
    self.navigationBarOfSelf.delegate = self;
}

- (void)closeViewController:(HPTabBarChildController *)childViewController
                   animated:(BOOL)flag
                 completion:(void (^)(void))completion
{
    HPTarBarController *rootViewController = (HPTarBarController *)self.parentViewController;
    
    [rootViewController closeViewController:self
                                   toTabBar:self.navigationBarOfTabBarController
                                   animated:flag
                                 completion:completion];

}

#pragma mark - HPTabBarProtocol

- (void)didClickTabBar:(HPTabBar *)tabbar
{
    [self closeViewController:self
                     animated:YES
                   completion:nil];
}
@end
