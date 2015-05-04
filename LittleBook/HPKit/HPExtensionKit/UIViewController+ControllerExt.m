//
//  UIViewController+ControllerKit.m
//  snapgrab
//
//  Created by hupeng on 14-10-30.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "UIViewController+ControllerExt.h"

@implementation UIViewController (ControllerExt)

- (UIViewController *)topestController
{
    UIViewController *topViewController = self;
    
    while (1) {
        
        if ([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = ((UITabBarController *)topViewController).selectedViewController;
            continue;
        }
        
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
            continue;
        }
        
        if (!topViewController.presentedViewController) {
            break;
        } else {
            topViewController = topViewController.presentedViewController;
            continue;
        }
    }
    return topViewController;
}

+ (id)loadFromStoryboard
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

@end
