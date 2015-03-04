//
//  HPTarBarController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

static const float kHPTabBarControllerAnimationDuration = 2.0;

#import "HPTarBarController.h"
#import "HPTabBarChildController.h"
#import "HPTabBarItem.h"

@interface HPTarBarController ()

@end

@implementation HPTarBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)openViewController:(HPTabBarChildController *)childViewController
                fromTabBar:(HPTabBarItem *)tabBar
                  animated:(BOOL)flag
                completion:(void (^)(void))completion

{
    CGRect rect = tabBar.frame;
    
    childViewController.navigationBar = [tabBar mutableCopy];
    
    if (!flag) {
        
        [self addChildViewController:childViewController];
        [self.view addSubview:childViewController.view];

        if (completion) {
            completion();
        }
        
        return;
    }
    
    childViewController.view.frame = rect;
    
    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];
    
    if (childViewController.navigationBar) {
        [childViewController.navigationBar startShowAnimationWithDuration:kHPTabBarControllerAnimationDuration completion:nil];
    }
    childViewController.view.alpha = 0.0;
    [UIView animateWithDuration:kHPTabBarControllerAnimationDuration animations:^{
        
        childViewController.view.alpha = 1.0;
        childViewController.view.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
    
}

- (void)closeViewController:(HPTabBarChildController *)childViewController
                   toTabBar:(HPTabBarItem *)tabBar
                   animated:(BOOL)flag
                 completion:(void (^)(void))completion
{
    CGRect rect = tabBar.frame;

    if (!flag) {

        [childViewController removeFromParentViewController];
        [childViewController.view removeFromSuperview];
        
        if (completion) {
            completion();
        }
        return;
    }
    if (childViewController.navigationBar) {
        [childViewController.navigationBar startHideAnimationWithDuration:kHPTabBarControllerAnimationDuration completion:nil];
    }
    
    [UIView animateWithDuration:kHPTabBarControllerAnimationDuration animations:^{
        
        childViewController.view.alpha = 0.0;
        childViewController.view.frame = rect;
        
    } completion:^(BOOL finished) {
        [childViewController removeFromParentViewController];
        [childViewController.view removeFromSuperview];
        
        if (completion) {
            completion();
        }
        
    }];

}

@end
