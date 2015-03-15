//
//  HPTarBarController.h
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPTabBar, HPTabBarChildController;

@interface HPTarBarController : UIViewController

@property (nonatomic, assign) HPTabBar *seletectedTabbar;
@property (nonatomic, strong) UIImageView *topFakeView;
@property (nonatomic, strong) UIImageView *bottomFakeView;

- (void)closeViewController:(HPTabBarChildController *)childViewController
                   animated:(BOOL)flag
                 completion:(void (^)(void))completion;

@end
