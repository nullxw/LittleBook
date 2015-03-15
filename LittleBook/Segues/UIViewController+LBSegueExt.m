//
//  UIViewController+LBSegueExt.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "UIViewController+LBSegueExt.h"

@implementation UIViewController (LBSegueExt)

- (void)dismissViewControllerPresentFromBottonWithMovingDirection:(HPPresentViewMovingDirection)direction
{
    
    float w = CGRectGetWidth(self.view.bounds);
    float h = CGRectGetHeight(self.view.bounds);
    
    CGRect toRect = CGRectZero;
    
    switch (direction) {
        case HPPresentViewMovingDirectionDown:
            toRect = CGRectMake(0, h, w, h);
            break;
        case HPPresentViewMovingDirectionUp:
            toRect = CGRectMake(0, -h, w, h);
            break;
        case HPPresentViewMovingDirectionLeft:
            toRect = CGRectMake(-w, 0, w, h);
            break;
        case HPPresentViewMovingDirectionRight:
            toRect = CGRectMake(w, 0, w, h);
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = toRect;
    } completion:^(BOOL finished) {
    
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}


- (void)dismissViewControllerPresentFromRight
{
    UIViewController *sourceViewController = self;
    UIViewController *viewControllerToPresent = self.navigationController.viewControllers[0];
    
    float w = CGRectGetWidth(sourceViewController.view.bounds);
    float h = CGRectGetHeight(sourceViewController.view.bounds);

    [sourceViewController.navigationController addChildViewController:viewControllerToPresent];
    [sourceViewController.navigationController.view addSubview:viewControllerToPresent.view];
    
    [sourceViewController removeFromParentViewController];
    
    [UIView animateWithDuration:0.3 animations:^{
        sourceViewController.view.frame = CGRectMake(w, 0, w, h);
        viewControllerToPresent.view.frame = CGRectMake(0, 0, w, h);
    } completion:^(BOOL finished) {
        [sourceViewController.view removeFromSuperview];
    }];
}
@end
