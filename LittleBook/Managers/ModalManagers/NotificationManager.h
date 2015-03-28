//
//  NotificationManager.h
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"

@interface NotificationManager : NSObject

@property (nonatomic, weak) Notification *preparedEntity;

+ (NotificationManager *)defaultManager;

- (Notification *)prepareNotificationEntity;
- (void)cleanContext;
- (void)saveContext;

@end

@interface NotificationManager (RetrieveExt)

- (NSArray *)findAll;
- (NSArray *)findAllofToday;

@end
