//
//  HPTarBarController.h
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPPresentViewController.h"

@class HPTabBar, HPTabBarChildController;

@interface HPTarBarController : HPPresentViewController

- (void)openViewController:(HPTabBarChildController *)childViewController
                fromTabBar:(HPTabBar *)tabBar
                  animated:(BOOL)flag
                completion:(void (^)(void))completion;

- (void)closeViewController:(HPTabBarChildController *)childViewController
                   toTabBar:(HPTabBar *)tabBar
                   animated:(BOOL)flag
                 completion:(void (^)(void))completion;

@end
