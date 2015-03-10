//
//  HPTarBarController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

static const float kHPTabBarControllerAnimationDuration = 0.45;

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

- (void)openViewController:(HPTabBarChildController *)childViewController
                fromTabBar:(HPTabBar *)tabBar
                  animated:(BOOL)flag
                completion:(void (^)(void))completion

{
    CGRect rect = [self.view convertRect:tabBar.frame fromView:tabBar.superview];
    childViewController.navigationBarOfTabBarController = tabBar;
    
    if (!flag) {
        
        [self addChildViewController:childViewController];
        [self.view addSubview:childViewController.view];

        if (completion) {
            completion();
        }
        return;
    }
    
    
    [self prepareForAnimation:rect];
    
    childViewController.view.frame = CGRectMake(0, CGRectGetMinY(rect), CGRectGetWidth(self.view.bounds), CGRectGetHeight(rect));
    childViewController.contentView.alpha = 0.0;

    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];

    if (childViewController.navigationBarOfSelf) {
        [childViewController.navigationBarOfSelf startShowAnimationWithDuration:kHPTabBarControllerAnimationDuration completion:nil];
    }
    
    [UIView animateWithDuration:kHPTabBarControllerAnimationDuration animations:^{
        childViewController.view.frame = self.view.bounds;
        childViewController.contentView.alpha = 1.0;
        childViewController.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(childViewController.view.frame), CGRectGetHeight(childViewController.view.frame));
        
        _topFakeView.frame = CGRectMake(0, -CGRectGetHeight(_topFakeView.frame), CGRectGetWidth(_topFakeView.frame), CGRectGetHeight(_topFakeView.frame));
        _bottomFakeView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(_bottomFakeView.frame), CGRectGetHeight(_bottomFakeView.frame));
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion();
        }
    }];
    
}

- (void)closeViewController:(HPTabBarChildController *)childViewController
                   toTabBar:(HPTabBar *)tabBar
                   animated:(BOOL)flag
                 completion:(void (^)(void))completion
{
    CGRect rect = [self.view convertRect:tabBar.frame fromView:tabBar.superview];

    if (!flag) {

        [childViewController removeFromParentViewController];
        [childViewController.view removeFromSuperview];
        
        if (completion) {
            completion();
        }
        return;
    }
    
    if (childViewController.navigationBarOfSelf) {
        [childViewController.navigationBarOfSelf startHideAnimationWithDuration:kHPTabBarControllerAnimationDuration completion:nil];
    }
    
    [UIView animateWithDuration:kHPTabBarControllerAnimationDuration animations:^{
        childViewController.contentView.alpha = 0.0;
        childViewController.view.frame = CGRectMake(0, CGRectGetMinY(rect), CGRectGetWidth(self.view.frame), CGRectGetHeight(rect));
        
        _topFakeView.frame = CGRectMake(0, 0, CGRectGetWidth(_topFakeView.frame), CGRectGetHeight(_topFakeView.frame));
        _bottomFakeView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_bottomFakeView.frame), CGRectGetWidth(_bottomFakeView.frame), CGRectGetHeight(_bottomFakeView.frame));
   
        
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

- (void)prepareForAnimation:(CGRect)rect
{
    float w = CGRectGetWidth(self.view.bounds);
    float h = CGRectGetHeight(self.view.bounds);
    
    CGRect topRect = CGRectMake(0, 0, w, rect.origin.y);
    CGRect bottomRect = CGRectMake(0, rect.origin.y + rect.size.height, w, h - CGRectGetMaxY(rect));
    UIImage *screenShot = [self.view viewShot];
    
    _topFakeView = [[UIImageView alloc] initWithFrame:topRect];
    _topFakeView.image = [screenShot clipToRect:topRect];
    [self.view addSubview:_topFakeView];
    
    _topFakeView = [[UIImageView alloc] initWithFrame:topRect];
    _topFakeView.image = [screenShot clipToRect:topRect];
    [self.view addSubview:_topFakeView];
    
    _bottomFakeView = [[UIImageView alloc] initWithFrame:bottomRect];
    _bottomFakeView.image = [screenShot clipToRect:bottomRect];
    [self.view addSubview:_bottomFakeView];
}

@end
