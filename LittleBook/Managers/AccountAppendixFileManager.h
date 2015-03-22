//
//  AccountAppendixFileManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPFileSystem.h"

@interface AccountAppendixFileManager : HPFileSystem

+ (AccountAppendixFileManager *)defaultManager;

- (void)saveAppendix:(NSData *)appendixData forAppendixID:(NSNumber *)appendxID;

- (NSString *)pathForAppendix:(NSNumber *)appendxID;

@end
