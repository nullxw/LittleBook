//
//  LBAppContext.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kLBNotificationSettingLowDiskSpace;
extern NSString *kLBNotificationSettingChargeUp;
extern NSString *kLBNotificationSettingCalendar;
extern NSString *kLBPanelStyleSetting;
extern NSString *kLBFontSizeSetting;
extern NSString *kLBFontNameSetting;
extern NSString *kLBResizeSetting;
extern NSString *kLBDragSetting;


@interface LBAppContext : NSObject

+ (instancetype)context;

@property (nonatomic, strong) NSMutableDictionary *settings;

- (void)updateSettings;

@property (nonatomic, strong) NSString *tempPath;


- (void)updateAccountNotifIfNeeded;

@end