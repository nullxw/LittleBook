//
//  NotificationSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificationSettingViewController.h"
//#import "UIViewController+HPPresentViewExt.h"
#import "NotificationSettingCell.h"
#import "LBAppContext.h"

@implementation NotificationSetting

@end

@interface NotificationSettingViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}
@end

@implementation NotificationSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    //1.
    NotificationSetting *storageSetting = [[NotificationSetting alloc] init];
    storageSetting.notificationDesc = @"储存容量较小提醒";
    storageSetting.notificationKey  = kLBNotificationSettingLowStorage;
    [_dataSource addObject:storageSetting];
    
    NotificationSetting *chargeSetting = [[NotificationSetting alloc] init];
    chargeSetting.notificationDesc = @"记账提醒";
    chargeSetting.notificationKey  = kLBNotificationSettingChargeUp;
    [_dataSource addObject:chargeSetting];
    
    
    NotificationSetting *calSetting = [[NotificationSetting alloc] init];
    calSetting.notificationDesc = @"日历提醒";
    calSetting.notificationKey  = kLBNotificationSettingCalendar;
    [_dataSource addObject:calSetting];
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

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationSettingCell"];
    NotificationSetting *notificationSetting = _dataSource[indexPath.row];
    NSMutableDictionary *settings = [LBAppContext context].settings;
    cell.descLabel.text = notificationSetting.notificationDesc;
    cell.switchView.on = [settings[notificationSetting.notificationKey] boolValue];
    cell.switchView.tag = indexPath.row;
    return cell;
}

//#pragma mark - HPPresentViewProtocol
//
//- (BOOL)presentView:(HPPresentView *)presentView shouldDismiss:(float)movingRatio
//{
//    return movingRatio > 0.25;
//}
//
//- (void)presentViewWillMovingFromSuperview:(HPPresentView *)presentView movingDriection:(HPPresentViewMovingDirection)direction
//{
//    [self dismissViewControllerAnimated:YES completion:nil movingDirection:direction];
//}

@end
