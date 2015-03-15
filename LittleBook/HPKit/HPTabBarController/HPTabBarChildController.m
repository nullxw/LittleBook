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

@interface HPTabBarChildController ()

@end

@implementation HPTabBarChildController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = TRUE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationBar) {
        [self.navigationBar startShowAnimationWithDuration:LB_SPRING_ANIMATION_TIME completion:nil];
    }
}

 - (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)dismiss
{
    HPTarBarController *rootViewController = (HPTarBarController *)self.parentViewController;
    
    [rootViewController closeViewController:self
                                   animated:TRUE
                                 completion:nil];

}

@end
