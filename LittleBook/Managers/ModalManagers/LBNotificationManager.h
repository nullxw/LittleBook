//
//  LBNotificationManager.h
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"

@interface LBNotificationManager : NSObject

@property (nonatomic, strong) Notification *preparedEntity;

+ (LBNotificationManager *)defaultManager;

- (Notification *)prepareNotificationEntityWith:(Notification *)notif;
- (void)cleanContext;
- (void)saveContext;

- (void)updateLocalNotification:(Notification *)notification;

@end

@interface LBNotificationManager (RetrieveExt)

// Retrieve
- (NSArray *)findAll;
- (NSArray *)findAllOfToday;

// Delete
- (void)deleteNotification:(Notification *)notification;

@end
