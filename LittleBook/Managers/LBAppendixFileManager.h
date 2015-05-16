//
//  LBAppendixFileManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPFileSystem.h"

@interface LBAppendixFileManager : HPFileSystem

+ (LBAppendixFileManager *)defaultManager;

// Create
- (void)saveAppendix:(NSData *)appendixData forAppendixID:(NSNumber *)appendxID;

// Retrieve
- (NSString *)pathForAppendix:(NSNumber *)appendxID;

- (NSString *)pathForAppendixThumbnail:(NSNumber *)appendxID;

// Delete
- (void)removeFilesForAppendix:(NSNumber *)appendxID;

@end
