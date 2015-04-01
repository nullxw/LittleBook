//
//  LBUserManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBUserManager.h"

static NSString *kLBDefaultUserID       = @"kLBDefaultUserID";
static NSString *kLBDefaultUserName     = @"Admin";
static NSString *kLBDefaultUserPassword = @"Admin";
@implementation LBUserManager

+ (LBUserManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBUserManager alloc] init]);
}

- (instancetype)init
{
    if (self = [super init]) {
        
        LBUser *defaultUser = [LBUser findFirstByAttribute:@"userID" withValue:kLBDefaultUserID];
        if (!defaultUser) {
            defaultUser = [LBUser createEntity];
            defaultUser.userID   = kLBDefaultUserID;
            defaultUser.name     = kLBDefaultUserName;
            defaultUser.password = kLBDefaultUserPassword;
            defaultUser.active   = @(TRUE);
        }
        self.currentUser = defaultUser;
    }
    return self;
}

@end
