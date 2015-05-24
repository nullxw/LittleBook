//
//  NotificationLBSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBNotificationSettingViewController.h"
#import "LBNotificationSettingCell.h"
#import "LBAppContext.h"

@implementation NotificationSetting

@end

@interface LBNotificationSettingViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}
@end

@implementation LBNotificationSettingViewController

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
            [[LBAppContext context] updateAccountNotifIfNeeded];
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
    LBNotificationSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBNotificationDotView"];
    NotificationSetting *notificationSetting = _dataSource[indexPath.row];
    NSMutableDictionary *settings = [LBAppContext context].settings;
    cell.descLabel.text = notificationSetting.notificationDesc;
    cell.switchView.on = [settings[notificationSetting.notificationKey] boolValue];
    cell.switchView.tag = indexPath.row;
    return cell;
}
@end
