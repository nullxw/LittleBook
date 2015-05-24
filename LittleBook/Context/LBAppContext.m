//
//  LBAppContext.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

static NSString *kLBUserDefaultSuiteName = @"kLBUserDefaultSuiteName";
static NSString *kLBAppSettingKey        = @"kLBAppSettingKey";

NSString *kLBNotificationSettingLowStorage = @"kLBNotificationSettingLowStorage";
NSString *kLBNotificationSettingChargeUp   = @"kLBNotificationSettingChargeUp";
NSString *kLBNotificationSettingCalendar   = @"kLBNotificationSettingCalendar";
NSString *kLBPanelStyleSetting = @"kLBPanelSetting";
NSString *kLBFontSizeSetting = @"kLBFontSizeSetting";
NSString *kLBFontNameSetting = @"kLBFontNameSetting";
NSString *kLBResizeSetting   = @"kLBResizeSetting";
NSString *kLBDragSetting     = @"kLBDragSetting";

#define LB_ACCOUNT_NOTIF_ID @"LB_ACCOUNT_NOTIF_ID"

#import "LBAppContext.h"
#import "HPFileSystem.h"

@interface LBAppContext ()
{
    NSUserDefaults *_userDefaults;
}
@end

@implementation LBAppContext

+ (instancetype)context
{
    static LBAppContext *_context = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (!_context) {
            _context = [[LBAppContext alloc] init];
        }
    });
    return _context;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kLBUserDefaultSuiteName];
        
        self.settings = [[_userDefaults objectForKey:kLBAppSettingKey] mutableCopy];
        
        if (!self.settings) {
            self.settings = @{kLBNotificationSettingLowStorage : @(TRUE),
                              kLBNotificationSettingChargeUp   : @(TRUE),
                              kLBNotificationSettingCalendar   : @(TRUE),
                              kLBPanelStyleSetting             : @"panelColor",
                              kLBFontNameSetting               : @"Helvetica-Neue",
                              kLBFontSizeSetting               : @(16),
                              kLBResizeSetting                 :@(TRUE),
                              kLBDragSetting                   :@(TRUE)
                              }.mutableCopy;
            
            
            [_userDefaults setObject:self.settings forKey:kLBAppSettingKey];
        }
    }
    return self;
}

- (void)updateSettings
{
    [_userDefaults setObject:self.settings forKey:kLBAppSettingKey];
}


- (NSString *)tempPath
{
    NSString *tempPath = [HPFileSystem cachePath];

    tempPath = [tempPath stringByAppendingPathComponent:@"temp.jpg"];
    
    return tempPath;
}

- (void)updateAccountNotifIfNeeded
{
    BOOL enableNotif = [self.settings[kLBNotificationSettingChargeUp] boolValue];
    
    UILocalNotification *notif = [self accountNotif];
    
    if (enableNotif) {
        
        notif.fireDate = [NSDate dateWithTimeInterval:7*24*3600 sinceDate:[NSDate new]];
    } else {
        [[UIApplication sharedApplication] cancelLocalNotification:notif];
    }
}

- (UILocalNotification *)accountNotif
{
    UILocalNotification *localNotification = [UILocalNotification findByID:LB_ACCOUNT_NOTIF_ID];
    
    if (!localNotification) {
        localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeInterval:7*24*3600 sinceDate:[NSDate new]];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody= @"亲，您已经一礼拜没有使用记帐本了。";
        localNotification.soundName= @"sound.wav";
        [localNotification setID:LB_ACCOUNT_NOTIF_ID];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    return localNotification;
}

@end
