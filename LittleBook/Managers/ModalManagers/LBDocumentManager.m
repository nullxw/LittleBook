//
//  LBDocumentManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentManager.h"
#import "LBIndexInfoManager.h"

@implementation LBDocumentManager

+ (Document *)document
{
    Document *doc = [Document createEntity];
    
    doc.documentID = [[LBIndexInfoManager defaultManager] getDocumentID];
    doc.createTime = [NSDate date];
    doc.userID = [LBUserManager defaultManager].currentUser.userID;
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return doc;
}

+ (Document *)findByID:(NSNumber *)docID inContext:(NSManagedObjectContext*)context
{
    if (!context) {
        return [Document findFirstWithPredicate:[NSPredicate predicateWithFormat:@"documentID=%@ and userID=%@", docID, [LBUserManager defaultManager].currentUser.userID]];
    } else {
        return [Document findFirstWithPredicate:[NSPredicate predicateWithFormat:@"documentID=%@ and userID=%@", docID, [LBUserManager defaultManager].currentUser.userID] inContext:context];
    }
}

+ (Document *)findByID:(NSNumber *)docID
{
    return [LBDocumentManager findByID:docID inContext:nil];
}

+ (NSArray *)findAll
{
    return [Document findByAttribute:@"userID" withValue:[LBUserManager defaultManager].currentUser.userID andOrderBy:@"createTime" ascending:NO];
}
@end
