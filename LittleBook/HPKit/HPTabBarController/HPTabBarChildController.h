//
//  HPTabBarChildController.h
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPPresentViewController.h"

@class HPTabBarItem;

@interface HPTabBarChildController : HPPresentViewController

@property (nonatomic, strong) HPTabBarItem *navigationBarOfTabBarController;

@property (nonatomic, strong) IBOutlet HPTabBarItem *navigationBarOfSelf;

- (void)closeViewController:(HPTabBarChildController *)childViewController
                   animated:(BOOL)flag
                 completion:(void (^)(void))completion;

@end
