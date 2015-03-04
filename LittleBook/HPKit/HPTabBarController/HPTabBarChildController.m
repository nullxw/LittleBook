//
//  HPTabBarChildController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPTabBarChildController.h"
#import "HPTabBarItem.h"

@interface HPTabBarChildController ()

@end

@implementation HPTabBarChildController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = TRUE;
}


- (void)setNavigationBar:(HPTabBarItem *)navigationBar
{
    _navigationBar = navigationBar;
    _navigationBar.center = CGPointMake(CGRectGetWidth(self.view.bounds) * 0.5, CGRectGetHeight(navigationBar.bounds)*0.5);
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_navigationBar];
}

@end
