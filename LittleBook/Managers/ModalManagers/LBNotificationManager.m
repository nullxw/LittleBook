//
//  LBNotificationManager.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBNotificationManager.h"
#import "LBIndexInfoManager.h"
#import "LBAppContext.h"
@interface LBNotificationManager ()
{
    BOOL _newEntity;
}
@end

@implementation LBNotificationManager

+ (LBNotificationManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBNotificationManager alloc] init]);
}

- (NSString *)getTodayID
{
    return [[NSDate new] formattedString:@"yyyy-MM-dd"];
}
- (Notification *)prepareNotificationEntityWith:(Notification *)notif;
{
    _newEntity = notif == nil;
    if (notif) {
        _preparedEntity = notif;
    } else {
        NSDate *now = [NSDate new];
        _preparedEntity = [Notification createEntity];
        _preparedEntity.createDate = now;
        _preparedEntity.fireDate   = now;
        _preparedEntity.dayID      = [self getTodayID];
        _preparedEntity.userID     = [LBUserManager defaultManager].currentUser.userID;
        _preparedEntity.on         = [LBAppContext context].settings[kLBNotificationSettingCalendar];
        _preparedEntity.label      = @"提醒";
        _preparedEntity.notifID    = [[LBIndexInfoManager defaultManager] getNotificationID];
    }
    return _preparedEntity;
}

- (void)cleanContext
{
    if (_newEntity) {
        [_preparedEntity deleteEntity];
        _preparedEntity = nil;
    }
}

- (void)saveContext
{
    //1.setup local notification
    [self updateLocalNotification:_preparedEntity];
    _preparedEntity = nil;
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        _preparedEntity = nil;
    }];
}

- (void)updateLocalNotification:(Notification *)notification
{
    UILocalNotification *localNotification = [self findLocalNotificationBy:notification.notifID];
    
    if (localNotification) {
        
        // update
        if (notification.on.boolValue) {
            localNotification.fireDate = notification.fireDate;
            localNotification.alertBody = notification.label;
        } else { // remove
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    } else {
        // create
        if (notification.on.boolValue) {
            localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = notification.fireDate;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.alertBody= notification.label;
            localNotification.soundName= UILocalNotificationDefaultSoundName;
//            localNotification.alertAction = @"稍后提醒";
//            localNotification.repeatInterval = kCFCalendarUnitMinute;
            localNotification.userInfo = @{@"notifID" : notification.notifID};
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    
    }
}

- (UILocalNotification *)findLocalNotificationBy:(NSNumber *)notifID
{
    NSArray *localNotificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *localNotification in localNotificaitons) {
    
        if ([localNotification.userInfo[@"notifID"] isEqual:notifID]) {
            return localNotification;
        }
    }
    return nil;
}
@end

@implementation LBNotificationManager (RetrieveExt)

- (NSArray *)findAll
{
    return [Notification findByAttribute:@"userID" withValue:[LBUserManager defaultManager].currentUser.userID andOrderBy:@"createTime" ascending:NO];
}

- (NSArray *)findAllofToday
{
    NSString *dayID = [self getTodayID];
    return [Notification findAllSortedBy:@"createDate" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and dayID=%@", [LBUserManager defaultManager].currentUser.userID, dayID]];

}

@end
