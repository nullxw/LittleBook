//
//  LBAccountManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountManager.h"
#import "LBIndexInfoManager.h"
#import "LBAppendixManager.h"


@implementation LBAccountManager

+ (LBAccountManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBAccountManager alloc] init]);
}

- (Account *)createAccountWithAppendixDatas:(NSArray *)appendixDatas
{
    Account *account = [Account createEntity];
    account.userID = [LBUserManager defaultManager].currentUser.userID;
    account.createTime = [NSDate new];
    account.accountID = [[LBIndexInfoManager defaultManager] getAccountID];
    
    for (UIImage *image in appendixDatas) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        Appendix *appendix = [[LBAppendixManager defaultManager] createAppendixWithMediaData:data];
        appendix.parentID = account.accountID;
    }
    return account;
}

- (NSArray *)findAll
{
    return [Account findByAttribute:@"userID" withValue:[LBUserManager defaultManager].currentUser.userID andOrderBy:@"createTime" ascending:NO];
}

@end
