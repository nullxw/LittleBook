//
//  LBSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBSettingViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "HPPresentView.h"

@interface LBSettingViewController ()<HPPresentViewProtocol>

@end

@implementation LBSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ((HPPresentView *)self.view).delegate = self;
}

#pragma mark - tabbar events

- (IBAction)didClickTabBar:(UIButton *)sender
{
    self.seletectedTabbar = (HPTabBar *)sender.superview;
}

#pragma mark - HPPresentViewProtocol

- (BOOL)presentView:(HPPresentView *)presentView shouldDismiss:(float)movingRatio
{
    return movingRatio > 0.25;
}

- (void)presentViewWillMovingFromSuperview:(HPPresentView *)presentView movingDriection:(HPPresentViewMovingDirection)direction
{
    [self dismissViewControllerPresentFromBottonWithMovingDirection:direction];
}
@end
