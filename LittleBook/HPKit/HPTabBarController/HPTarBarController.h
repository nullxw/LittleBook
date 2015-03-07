//
//  HPTarBarController.h
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPPresentViewController.h"

@class HPTabBarItem, HPTabBarChildController;

@interface HPTarBarController : HPPresentViewController

- (void)openViewController:(HPTabBarChildController *)childViewController
                fromTabBar:(HPTabBarItem *)tabBar
                  animated:(BOOL)flag
                completion:(void (^)(void))completion;

- (void)closeViewController:(HPTabBarChildController *)childViewController
                   toTabBar:(HPTabBarItem *)tabBar
                   animated:(BOOL)flag
                 completion:(void (^)(void))completion;

@end
