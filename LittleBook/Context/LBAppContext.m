//
//  LBAppContext.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

static NSString *kLBUserDefaultSuiteName = @"kLBUserDefaultSuiteName";
static NSString *kLBAppSettingKey        = @"kLBAppSettingKey";


#import "LBAppContext.h"

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
            self.settings = @{kLBNotificationSettingLowStorage : @(FALSE),
                              kLBNotificationSettingChargeUp   : @(FALSE),
                              kLBNotificationSettingCalendar   : @(FALSE)}.mutableCopy;
            [_userDefaults setObject:self.settings forKey:kLBAppSettingKey];
        }
    }
    return self;
}


- (void)updateSettings
{
    [_userDefaults setObject:self.settings forKey:kLBAppSettingKey];
}

@end
