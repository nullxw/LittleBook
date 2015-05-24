//
//  HPTarBarController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPTarBarController.h"
#import "HPTabBarChildController.h"
#import "HPTabBar.h"

@interface HPTarBarController ()
{
    UIImageView *_topFakeView;
    UIImageView *_bottomFakeView;
}

@end

@implementation HPTarBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)closeViewController:(HPTabBarChildController *)childViewController
                   animated:(BOOL)flag
                 completion:(void (^)(void))completion
{
    HPTabBar *tabBar = self.seletectedTabbar;
    
    CGRect rect = [self.view convertRect:tabBar.frame fromView:tabBar.superview];

    if (!flag) {

        [childViewController removeFromParentViewController];
        [childViewController.view removeFromSuperview];
        
        if (completion) {
            completion();
        }
        return;
    }
    
    if (childViewController.navigationBar) {
        [childViewController.navigationBar startHideAnimationWithDuration:LB_LINEAR_ANIMATION_TIME completion:nil];
    }
    
    [self viewWillAppear:TRUE];
  
    [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
        childViewController.contentView.alpha = 0.0;
        childViewController.view.frame = CGRectMake(0, CGRectGetMinY(rect), CGRectGetWidth(self.view.frame), CGRectGetHeight(rect));
        
        self.topFakeView.frame = CGRectMake(0, 0, CGRectGetWidth(_topFakeView.frame), CGRectGetHeight(_topFakeView.frame));
        self.bottomFakeView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_bottomFakeView.frame), CGRectGetWidth(_bottomFakeView.frame), CGRectGetHeight(_bottomFakeView.frame));
   
        
    } completion:^(BOOL finished) {
        [childViewController removeFromParentViewController];
        [childViewController.view removeFromSuperview];
        [_topFakeView removeFromSuperview];
        [_bottomFakeView removeFromSuperview];
        if (completion) {
            completion();
        }
        
    }];
}

@end
