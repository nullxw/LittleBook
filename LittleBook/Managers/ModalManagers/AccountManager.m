//
//  AccountManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AccountManager.h"
#import "IndexInfoManager.h"
#import "AppendixManager.h"


@implementation AccountManager

+ (AccountManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[AccountManager alloc] init]);
}

- (Account *)createAccountWithAppendixDatas:(NSArray *)appendixDatas
{
    Account *account = [Account createEntity];
    account.userID = [UserManager defaultManager].currentUser.userID;
    account.createTime = [NSDate new];
    account.accountID = [[IndexInfoManager defaultManager] getAccountID];
    
    for (UIImage *image in appendixDatas) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        Appendix *appendix = [[AppendixManager defaultManager] createAppendixWithMediaData:data];
        appendix.parentID = account.accountID;
    }
    return account;
}

- (NSArray *)findAll
{
    return [Account findByAttribute:@"userID" withValue:[UserManager defaultManager].currentUser.userID andOrderBy:@"createTime" ascending:NO];
}

@end
