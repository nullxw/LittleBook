//
//  LBAccountManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountManager.h"

@implementation LBAccountManager

+ (Account *)findByDate:(NSDate *)date
{
    NSString *accountID = [Account generateAccountIDFromDate:date];
    
    return [Account findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and accountID=%@", [LBUserManager defaultManager].currentUser.userID, accountID]];
}

+ (Account *)findByID:(NSString *)accountID
{
    return [Account findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and accountID=%@", [LBUserManager defaultManager].currentUser.userID, accountID]];
}

+ (NSArray *)findAll
{
    return [Account findByAttribute:@"userID" withValue:[LBUserManager defaultManager].currentUser.userID andOrderBy:@"createTime" ascending:NO];
}

+ (Account *)createFromDate:(NSDate *)date
{
    Account *account   = [Account createEntity];
    account.accountID  = [Account generateAccountIDFromDate:date];
    account.createTime = [NSDate new];
    account.userID     = [LBUserManager defaultManager].currentUser.userID;
    account.totalCost  = @(0);
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    
    return account;
}
@end
