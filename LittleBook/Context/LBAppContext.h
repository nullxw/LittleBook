//
//  LBAppContext.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *kLBNotificationSettingLowStorage;
extern const NSString *kLBNotificationSettingChargeUp;
extern const NSString *kLBNotificationSettingCalendar;
extern const NSString *kLBPanelStyleSetting;
extern const NSString *kLBFontSizeSetting;
extern const NSString *kLBFontNameSetting;
extern const NSString *kLBResizeSetting;
extern const NSString *kLBDragSetting;


@interface LBAppContext : NSObject

+ (instancetype)context;

@property (nonatomic, strong) NSMutableDictionary *settings;

- (void)updateSettings;

@property (nonatomic, strong) NSString *tempPath;

@end