//
//  NotificationManager.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager

+ (NotificationManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[NotificationManager alloc] init]);
}

- (NSString *)getTodayID
{
    return [[NSDate new] formattedString:@"yyyy-MM-dd"];
}
- (Notification *)prepareNotificationEntity
{
    NSDate *now = [NSDate new];
    _preparedEntity = [Notification createEntity];
    _preparedEntity.createDate = now;
    _preparedEntity.dayID = [self getTodayID];
    _preparedEntity.userID = [UserManager defaultManager].currentUser.userID;
    return _preparedEntity;
}

- (void)cleanContext
{
    [_preparedEntity deleteEntity];
    _preparedEntity = nil;
}

- (void)saveContext
{
    [[NSManagedObjectContext defaultContext] saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError *error) {
        _preparedEntity = nil;
    }];
}
@end

@implementation NotificationManager (RetrieveExt)

- (NSArray *)findAll
{
    return [Notification findByAttribute:@"userID" withValue:[UserManager defaultManager].currentUser.userID andOrderBy:@"createTime" ascending:NO];
}

- (NSArray *)findAllofToday
{
    NSString *dayID = [self getTodayID];
    return [Notification findAllSortedBy:@"createDate" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and dayID=%@", [UserManager defaultManager].currentUser.userID, dayID]];

}

@end
