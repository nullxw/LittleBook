//
//  LBAppendixManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAppendixManager.h"
#import "LBIndexInfoManager.h"
#import "LBAppendixFileManager.h"

@implementation LBAppendixManager

+ (Appendix *)createAppendixWithMediaData:(NSData *)data
{
    Appendix *appendix = [Appendix createEntity];
    appendix.userID = [LBUserManager defaultManager].currentUser.userID;
    appendix.appendixID = [[LBIndexInfoManager defaultManager] getAppendixID];
    
    [[LBAppendixFileManager defaultManager] saveAppendix:data forAppendixID:appendix.appendixID];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return appendix;
}

+ (NSArray *)appendixs:(NSNumber *)parentID
{
    return [LBAppendixManager appendixs:parentID inContext:nil];
}

+ (NSArray *)appendixs:(NSNumber *)parentID inContext:(NSManagedObjectContext *)context
{
    NSString *userID = [LBUserManager defaultManager].currentUser.userID;
    
    if (!context) {
        return [Appendix findAllWithPredicate:[NSPredicate predicateWithFormat:@"parentID=%@ and userID=%@", parentID, userID]];
    } else {
        return [Appendix findAllWithPredicate:[NSPredicate predicateWithFormat:@"parentID=%@ and userID=%@", parentID, userID] inContext:context];
    }
}

+ (Appendix *)findByID:(NSNumber *)appendixID
{
    return [LBAppendixManager findByID:appendixID inContext:nil];
}


+ (Appendix *)findByID:(NSNumber *)appendixID inContext:(NSManagedObjectContext *)context
{
    NSString *userID = [LBUserManager defaultManager].currentUser.userID;
    if (!context) {
        return  [Appendix findFirstWithPredicate:[NSPredicate predicateWithFormat:@"appendixID=%@ and userID=%@", appendixID, userID]];
    } else {
        return  [Appendix findFirstWithPredicate:[NSPredicate predicateWithFormat:@"appendixID=%@ and userID=%@", appendixID, userID] inContext:context];
    }

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
