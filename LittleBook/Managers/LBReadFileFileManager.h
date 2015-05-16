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

// Retrieve
- (NSString *)pathForReadFile:(NSNumber *)fileID;

- (NSString *)pathForThumbnail:(NSNumber *)fileID;

// Delete
- (void)removeReadFile:(NSNumber *)fileID;

@end
