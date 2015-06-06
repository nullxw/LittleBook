//
//  LBReadFileManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBReadFileManager.h"
#import "LBAppendixManager.h"
#import "LBIndexInfoManager.h"
#import "Document.h"

@implementation LBReadFileManager

+ (ReadFile *)createReadFileFromDocument:(Document *)doc
{
    ReadFile *readFile = [ReadFile createEntity];
    readFile.createTime = [NSDate new];
    readFile.userID = [LBUserManager defaultManager].currentUser.userID;
    readFile.fileID = [[LBIndexInfoManager defaultManager] getFileID];
    readFile.title = doc.title;
    readFile.content = doc.content;
    
    Appendix *thumbnailAppendix = [LBAppendixManager thumbnailAppendixOf:doc.documentID];
    if (thumbnailAppendix) {
        readFile.thumbnailID = thumbnailAppendix.appendixID;
    }
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return readFile;
}

+ (NSArray *)findAll
{
    return [ReadFile findByAttribute:@"userID" withValue:[LBUserManager defaultManager].currentUser.userID andOrderBy:@"createTime" ascending:NO];
}

+ (ReadFile *)findByID:(NSNumber *)fileID
{
    return [ReadFile findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fileID=%@ and userID=%@", fileID, [LBUserManager defaultManager].currentUser.userID]];
}

+ (void)deleteReadFile:(ReadFile *)file
{
    [file deleteEntity];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}
@end