//
//  LBReadFileFileManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/5/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPFileSystem.h"

@interface LBReadFileFileManager : HPFileSystem

+ (LBReadFileFileManager *)defaultManager;

// Create
- (void)saveReadFileImage:(NSNumber *)fileID withData:(NSData *)data;

// Retrieve
- (NSString *)pathForReadFile:(NSNumber *)fileID;

- (NSString *)pathForReadFileImage:(NSNumber *)fileID;

- (NSString *)pathForThumbnail:(NSNumber *)fileID;

// Delete
- (void)removeReadFile:(NSNumber *)fileID;

@end
