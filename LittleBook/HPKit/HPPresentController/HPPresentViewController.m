//
//  HPPresentViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

static const float kHPPresentViewControllerAnimationDuration = 0.45;

#import "HPPresentViewController.h"

@interface HPPresentViewController ()

@end

@implementation HPPresentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];       
}

#pragma mark - present and dismiss view controller

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                fromDirection:(HPPresentViewControllerAnimationDirection)direction
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion
{
    if (!flag) {
        
        [self addChildViewController:viewControllerToPresent];
        [self.view addSubview:viewControllerToPresent.view];
        
        if (completion) {
            completion();
        }
        
        return;
    }
    
    float w = CGRectGetWidth(self.view.bounds);
    float h = CGRectGetHeight(self.view.bounds);
    
    CGRect fromRect = CGRectZero;
    
    switch (direction) {
        case HPPresentViewControllerAnimationDirectionFromBottom:
            fromRect = CGRectMake(0, h, w, h);
            break;
        case HPPresentViewControllerAnimationDirectionFromTop:
            fromRect = CGRectMake(0, -h, w, h);
            break;
        case HPPresentViewControllerAnimationDirectionFromLeft:
            fromRect = CGRectMake(-w, 0, w, h);
            break;
        case HPPresentViewControllerAnimationDirectionFromRight:
            fromRect = CGRectMake(w, 0, w, h);
            break;
        default:
            
            break;
    }
    
    viewControllerToPresent.view.frame = fromRect;
    [self addChildViewController:viewControllerToPresent];
    [self.view addSubview:viewControllerToPresent.view];
    
    [UIView animateWithDuration:kHPPresentViewControllerAnimationDuration animations:^{
        
        viewControllerToPresent.view.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)dismissViewControllerFromDirection:(HPPresentViewControllerAnimationDirection)direction
                                  animated:(BOOL)flag
                                completion:(void (^)(void))completion
{
    if (!flag) {
        
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
        if (completion) {
            completion();
        }
        return;
    }
    
    float w = CGRectGetWidth(self.view.bounds);
    float h = CGRectGetHeight(self.view.bounds);
    
    CGRect toRect = CGRectZero;
    
    switch (direction) {
        case HPPresentViewControllerAnimationDirectionFromBottom:
            toRect = CGRectMake(0, -h, w, h);
            break;
        case HPPresentViewControllerAnimationDirectionFromTop:
            toRect = CGRectMake(0, h, w, h);
            break;
        case HPPresentViewControllerAnimationDirectionFromLeft:
            toRect = CGRectMake(w, 0, w, h);
            break;
        case HPPresentViewControllerAnimationDirectionFromRight:
            toRect = CGRectMake(-w, 0, w, h);
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:kHPPresentViewControllerAnimationDuration animations:^{
        self.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
        if (completion) {
            completion();
        }
    }];
}

@end
