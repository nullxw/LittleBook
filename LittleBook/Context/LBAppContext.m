//
//  LBAppContext.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

static NSString *kLBUserDefaultSuiteName = @"kLBUserDefaultSuiteName";
static NSString *kLBAppSettingKey        = @"kLBAppSettingKey";

const NSString *kLBNotificationSettingLowStorage = @"kLBNotificationSettingLowStorage";
const NSString *kLBNotificationSettingChargeUp   = @"kLBNotificationSettingChargeUp";
const NSString *kLBNotificationSettingCalendar   = @"kLBNotificationSettingCalendar";
const NSString *kLBPanelStyleSetting = @"kLBPanelSetting";
const NSString *kLBFontSizeSetting = @"kLBFontSizeSetting";
const NSString *kLBFontNameSetting = @"kLBFontNameSetting";
const NSString *kLBResizeSetting   = @"kLBResizeSetting";
const NSString *kLBDragSetting     = @"kLBDragSetting";


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
@end
