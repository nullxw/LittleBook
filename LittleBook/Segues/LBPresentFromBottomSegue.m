//
//  LBPresentFromBottomSegue.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBPresentFromBottomSegue.h"

@implementation LBPresentFromBottomSegue

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *viewControllerToPresent = self.destinationViewController;
    
    float w = CGRectGetWidth(sourceViewController.view.bounds);
    float h = CGRectGetHeight(sourceViewController.view.bounds);
    
    viewControllerToPresent.view.frame = CGRectMake(0, h, w, h);
    [sourceViewController addChildViewController:viewControllerToPresent];
    [sourceViewController.view addSubview:viewControllerToPresent.view];
    
    [sourceViewController viewWillDisappear:TRUE];
    [viewControllerToPresent viewWillAppear:TRUE];
    
    [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        viewControllerToPresent.view.frame = CGRectMake(0, 0, w, h);
        
    } completion:^(BOOL finished) {
    }];
}
@end
