//
//  LBAppendixManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAppendixManager.h"
#import "LBIndexInfoManager.h"
#import "LBAccountAppendixFileManager.h"

@implementation LBAppendixManager

+ (Appendix *)createAppendixWithMediaData:(NSData *)data
{
    Appendix *appendix = [Appendix createEntity];
    appendix.userID = [LBUserManager defaultManager].currentUser.userID;
    appendix.appendixID = [[LBIndexInfoManager defaultManager] getAppendixID];
    
    [[LBAccountAppendixFileManager defaultManager] saveAppendix:data forAppendixID:appendix.appendixID];
    return appendix;
}

+ (NSArray *)appendixsOfAccountDetail:(NSNumber *)accountID
{
    return [Appendix findAllWithPredicate:[NSPredicate predicateWithFormat:@"parentID=%@ and userID=%@", accountID, [LBUserManager defaultManager].currentUser.userID]];
}

+ (Appendix *)findByID:(NSNumber *)appendixID
{
    return [Appendix findFirstWithPredicate:[NSPredicate predicateWithFormat:@"appendixID=%@ and userID=%@", appendixID, [LBUserManager defaultManager].currentUser.userID]];
}

+ (NSArray *)findByIDs:(NSArray *)appendixIDs
{
    NSMutableArray *appendixs = @[].mutableCopy;
    
    for (NSNumber *appendixID in appendixIDs) {
        Appendix *appendix = [LBAppendixManager findByID:appendixID];
        if (appendix) {
            [appendixs addObject:appendix];
        }
    }
    return appendixs;
}
@end
