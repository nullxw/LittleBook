//
//  AppendixManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AppendixManager.h"
#import "IndexInfoManager.h"
#import "AccountAppendixFileManager.h"

@implementation AppendixManager

+ (AppendixManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[AppendixManager alloc] init]);
}

- (Appendix *)createAppendixWithMediaData:(NSData *)data
{
    Appendix *appendix = [Appendix createEntity];
    appendix.userID = [UserManager defaultManager].currentUser.userID;
    appendix.appendixID = [[IndexInfoManager defaultManager] getAppendixID];
    
    [[AccountAppendixFileManager defaultManager] saveAppendix:data forAppendixID:appendix.appendixID];
    return appendix;
}

- (NSArray *)appendixOfAccount:(NSNumber *)accountID
{
    return [Appendix findAllWithPredicate:[NSPredicate predicateWithFormat:@"parentID=%@ and userID=%@", accountID, [UserManager defaultManager].currentUser.userID]];
}

- (Appendix *)findByID:(NSNumber *)appendixID
{
    return [Appendix findFirstWithPredicate:[NSPredicate predicateWithFormat:@"appendixID=%@ and userID=%@", appendixID, [UserManager defaultManager].currentUser.userID]];
}

@end
