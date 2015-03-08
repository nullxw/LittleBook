//
//  SettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+HPPresentViewExt.h"
#import "NotificationSettingViewController.h"
#import "CustomSettingViewController.h"
#import "PanelSettingViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "LBNavigationBar.h"

@interface SettingViewController ()<HPPresentViewProtocol, HPTabBarItemProtocol>

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - HPPresentViewProtocol

- (BOOL)presentView:(HPPresentView *)presentView shouldDismiss:(float)movingRatio
{
    return movingRatio > 0.25;
}

- (void)presentViewWillMovingFromSuperview:(HPPresentView *)presentView movingDriection:(HPPresentViewMovingDirection)direction
{
    [self dismissViewControllerAnimated:YES completion:nil movingDirection:direction];
}

#pragma mark - HPTabBarItemProtocol

- (void)didClickTabBar:(HPTabBarItem *)tabbar
{
    HPTabBarChildController *vc = nil;
    NSInteger tag = tabbar.tag;
    switch (tag) {
        case 0:
            vc = [LoginViewController loadFromStoryboard];
            break;
        case 1:
            vc = [PanelSettingViewController loadFromStoryboard];
            break;
        case 2:
            vc = [CustomSettingViewController loadFromStoryboard];
            break;
        case 3:
            vc = [NotificationSettingViewController loadFromStoryboard];
            break;
        case 4:
            vc = [AboutViewController loadFromStoryboard];
            break;
        default:
            break;
    }
    [self openViewController:vc
                  fromTabBar:tabbar
                    animated:YES
                  completion:nil];
}


@end
