//
//  LBTabbarSegue.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBTabbarSegue.h"
#import "HPTabBarChildController.h"
#import "HPTarBarController.h"
#import "HPTabBar.h"

@implementation LBTabbarSegue

- (void)perform
{
    HPTarBarController *sourceViewController = self.sourceViewController;
    HPTabBarChildController *viewControllerToPresent = self.destinationViewController;
    
    CGRect rect = [sourceViewController.view convertRect:sourceViewController.seletectedTabbar.frame fromView:sourceViewController.seletectedTabbar.superview];
    
    float w = CGRectGetWidth(sourceViewController.view.bounds);
    float h = CGRectGetHeight(sourceViewController.view.frame);
    
    [self prepareForAnimation:rect];
    
    viewControllerToPresent.view.frame = CGRectMake(0, CGRectGetMinY(rect), w, CGRectGetHeight(rect));
    viewControllerToPresent.contentView.alpha = 0.0;
    
    [sourceViewController addChildViewController:viewControllerToPresent];
    [sourceViewController.view addSubview:viewControllerToPresent.view];
    
    [sourceViewController viewWillDisappear:TRUE];
    [viewControllerToPresent viewWillAppear:TRUE];
    
    [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        viewControllerToPresent.view.frame = sourceViewController.view.bounds;
        viewControllerToPresent.contentView.alpha = 1.0;
        viewControllerToPresent.contentView.frame = CGRectMake(0, 0, w, h);
        
        sourceViewController.topFakeView.frame = CGRectMake(0, -CGRectGetHeight(sourceViewController.topFakeView.frame), CGRectGetWidth(sourceViewController.topFakeView.frame), CGRectGetHeight(sourceViewController.topFakeView.frame));
        sourceViewController.bottomFakeView.frame = CGRectMake(0, h, CGRectGetWidth(sourceViewController.bottomFakeView.frame), CGRectGetHeight(sourceViewController.bottomFakeView.frame));
        
    } completion:^(BOOL finished) {
    }];

}

- (void)prepareForAnimation:(CGRect)rect
{
    HPTarBarController *sourceViewController = self.sourceViewController;
    
    float w = CGRectGetWidth(sourceViewController.view.bounds);
    float h = CGRectGetHeight(sourceViewController.view.bounds);
    
    CGRect topRect = CGRectMake(0, 0, w, rect.origin.y);
    CGRect bottomRect = CGRectMake(0, rect.origin.y + rect.size.height, w, h - CGRectGetMaxY(rect));
    UIImage *screenShot = [sourceViewController.view viewShot];
    
    sourceViewController.topFakeView = [[UIImageView alloc] initWithFrame:topRect];
    sourceViewController.topFakeView.image = [screenShot clipToRect:topRect];
    [sourceViewController.view addSubview:sourceViewController.topFakeView];
    
    sourceViewController.bottomFakeView = [[UIImageView alloc] initWithFrame:bottomRect];
    sourceViewController.bottomFakeView.image = [screenShot clipToRect:bottomRect];
    [sourceViewController.view addSubview:sourceViewController.topFakeView];
}

@end
