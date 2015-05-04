//
//  LBAccountManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountManager.h"
#import "LBAccountDetailManager.h"

@implementation LBAccountManager

+ (Account *)findByDate:(NSDate *)date
{
    NSString *accountID = [Account generateAccountIDFromDate:date];
    
    return [Account findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and accountID=%@", [LBUserManager defaultManager].currentUser.userID, accountID]];
}

+ (Account *)findByID:(NSString *)accountID inContext:(NSManagedObjectContext *)context
{
    NSString *userID = [LBUserManager defaultManager].currentUser.userID;
    if (!context) {
        return [Account findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and accountID=%@", userID, accountID]];
    } else {
        return [Account findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and accountID=%@", userID, accountID] inContext:context];
    }
}

+ (Account *)findByID:(NSString *)accountID
{
    return [LBAccountManager findByID:accountID inContext:nil];
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

+ (void)deleteAccount:(Account *)account
{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
       
        Account *localAccount = [LBAccountManager findByID:account.accountID inContext:localContext];
        
        NSArray *localAccountDetails = [LBAccountDetailManager findAllOfAccount:localAccount.accountID inContext:localContext];
        
        for (AccountDetail *accountDetail in localAccountDetails) {
            [LBAccountDetailManager deleteAccountDetail:accountDetail inContext:localContext];
        }
        
        [localAccount deleteEntityInContext:localContext];
    }];
}
@end
