//
//  NotificationSettingViewController.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPTabBarChildController.h"

@interface NotificationSetting : NSObject

@property (nonatomic, strong) NSString *notificationKey;
@property (nonatomic, strong) NSString *notificationDesc;

@end

@interface NotificationSettingViewController : HPTabBarChildController

@end
