//
//  LBAppContext.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kLBNotificationSettingLowStorage = @"kLBNotificationSettingLowStorage";
static NSString *kLBNotificationSettingChargeUp   = @"kLBNotificationSettingChargeUp";
static NSString *kLBNotificationSettingCalendar   = @"kLBNotificationSettingCalendar";

@interface LBAppContext : NSObject

+ (instancetype)context;

@property (nonatomic, strong) NSMutableDictionary *settings;

- (void)updateSettings;

@end