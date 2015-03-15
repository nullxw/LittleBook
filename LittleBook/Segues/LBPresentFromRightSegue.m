//
//  LBPresentFromRightSegue.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBPresentFromRightSegue.h"

@implementation LBPresentFromRightSegue

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *viewControllerToPresent = self.destinationViewController;
    
    float w = CGRectGetWidth(sourceViewController.view.bounds);
    float h = CGRectGetHeight(sourceViewController.view.bounds);
    
    viewControllerToPresent.view.frame = CGRectMake(w, 0, w, h);
    
    [sourceViewController.navigationController addChildViewController:viewControllerToPresent];
    [sourceViewController.navigationController.view addSubview:viewControllerToPresent.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        sourceViewController.view.frame = CGRectMake(-w, 0, w, h);
        viewControllerToPresent.view.frame = CGRectMake(0, 0, w, h);
    } completion:^(BOOL finished) {

    }];
}

@end
