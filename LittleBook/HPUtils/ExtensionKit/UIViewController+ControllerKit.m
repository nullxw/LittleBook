//
//  UIViewController+ControllerKit.m
//  snapgrab
//
//  Created by hupeng on 14-10-30.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "UIViewController+ControllerKit.h"

@implementation UIViewController (ControllerKit)

- (UIViewController *)topestController
{
    UIViewController *topViewController = self;
    while (1) {
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        }
        
        if ([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = ((UITabBarController *)topViewController).selectedViewController;
        }
        
        UIViewController *tempViewController;
        if (topViewController.navigationController) {
            tempViewController = [topViewController.navigationController topViewController];
            if ([tempViewController isEqual:topViewController]) {
                topViewController = tempViewController;
                break;
            }
            topViewController = tempViewController;
            
        } else {
            tempViewController = topViewController.presentedViewController;
            if (!tempViewController) {
                break;
            }
            topViewController = tempViewController;
        }
    }
    return topViewController;
}

+ (id)loadFromStoryboard
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

@end
