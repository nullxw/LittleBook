//
//  NotificationSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificationSettingViewController.h"
#import "UIViewController+HPPresentViewExt.h"
#import "LBAppContext.h"

@interface NotificationSettingViewController ()

@end

@implementation NotificationSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - events

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    NSMutableDictionary *settings = [LBAppContext context].settings;
    
    switch (sender.tag) {
        case 0:
            settings[kLBNotificationSettingLowStorage] = @(sender.on);
            break;
        case 1:
            settings[kLBNotificationSettingChargeUp] = @(sender.on);
            break;
        case 2:
            settings[kLBNotificationSettingCalendar] = @(sender.on);
            break;
        default:
            break;
    }
    [[LBAppContext context] updateSettings];
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
