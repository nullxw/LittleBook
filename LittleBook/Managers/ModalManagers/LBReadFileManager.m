//
//  LBReadFileManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBReadFileManager.h"
#import "Document.h"

@implementation LBReadFileManager

+ (ReadFile *)createReadFileFromDocument:(Document *)doc
{
    ReadFile *readFile = [ReadFile createEntity];
    readFile.createTime = [NSDate new];
    readFile.fileID = doc.documentID;
    readFile.userID = [LBUserManager defaultManager].currentUser.userID;
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return readFile;
}

+ (NSArray *)findAll
{
    return [ReadFile findByAttribute:@"userID" withValue:[LBUserManager defaultManager].currentUser.userID andOrderBy:@"createTime" ascending:NO];
}

+ (void)deleteReadFile:(ReadFile *)file;
{
    [file deleteEntity];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}
@end