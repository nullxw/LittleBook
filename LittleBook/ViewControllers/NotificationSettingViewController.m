//
//  NotificationSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificationSettingViewController.h"
#import "UIViewController+HPPresentViewExt.h"

@interface NotificationSettingViewController ()

@end

@implementation NotificationSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
