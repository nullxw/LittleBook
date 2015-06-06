//
//  LBAccountDetailManager.m
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountDetailManager.h"
#import "LBIndexInfoManager.h"
#import "LBAppendixManager.h"
#import "LBAccountManager.h"
#import "LBAppContext.h"

@implementation LBAccountDetailManager

+ (AccountDetail *)createAccountWithAppendixDatas:(NSArray *)appendixDatas
                                      description:(NSString *)desc
                                          andCost:(NSNumber *)cost
                                         parentID:(NSString *)parentID
{
    AccountDetail *accountDetail = [AccountDetail createEntity];
    accountDetail.userID     = [LBUserManager defaultManager].currentUser.userID;
    accountDetail.createTime = [NSDate new];
    accountDetail.accountID  = [[LBIndexInfoManager defaultManager] getFileID];
    accountDetail.desc       = desc;
    accountDetail.cost       = cost;
    
    NSMutableArray *appendixIDs = @[].mutableCopy;
    
    // update appendix's info
    for (UIImage *image in appendixDatas) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        Appendix *appendix = [LBAppendixManager createAppendixWithMediaData:data];
        appendix.parentID = accountDetail.accountID;
        
        [appendixIDs addObject:appendix.appendixID.stringValue];
    }
    
    NSString *_parentID = parentID ? parentID : [Account generateAccountIDFromDate:accountDetail.createTime];
    
    // update account's info
    Account *account = [LBAccountManager findByID:_parentID];
    if (!account) {
        account = [LBAccountManager createFromDate:accountDetail.createTime];
    }
    account.totalCost = @(account.totalCost.integerValue + cost.integerValue);
    [account updateAccountAppendixs:appendixIDs];
    accountDetail.parentID = account.accountID;
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    
    [[LBAppContext context] updateAccountNotifIfNeeded];
    
    return accountDetail;
}

+ (NSArray *)findAllOfAccount:(NSString *)parentID
{
    return [LBAccountDetailManager findAllOfAccount:parentID inContext:nil];
}

+ (NSArray *)findAllOfAccount:(NSString *)parentID inContext:(NSManagedObjectContext *)context
{
    NSString *userID = [LBUserManager defaultManager].currentUser.userID;
    if (!context) {
        return [AccountDetail findAllSortedBy:@"createTime" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and parentID=%@",userID , parentID]];
    } else {
        return [AccountDetail findAllSortedBy:@"createTime" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"userID=%@ and parentID=%@",userID , parentID] inContext:context];
    
    }
}


+ (void)deleteAccountDetail:(AccountDetail *)accountDetail inContext:(NSManagedObjectContext *)context
{
    NSArray *appendixs = [LBAppendixManager appendixs:accountDetail.accountID inContext:context];
    for (Appendix *appendix in appendixs) {
        [appendix deleteEntityInContext:context];
    }
    [accountDetail deleteEntityInContext:context];

}
@end
