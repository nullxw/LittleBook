//
//  AccountAppendixFileManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//
#define ACCOUNT_APPENDIX_NAME(APPENDIXID) [NSString stringWithFormat:@"APPENDIX_%@", APPENDIXID]

#import "AccountAppendixFileManager.h"

@implementation AccountAppendixFileManager

+ (AccountAppendixFileManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[AccountAppendixFileManager alloc] init]);
}

- (NSString *)directory
{
    return @"AccountAppendix";
}

- (NSSearchPathDirectory)rootDirectory
{
    return NSDocumentDirectory;
}

- (void)saveAppendix:(NSData *)appendixData forAppendixID:(NSNumber *)appendxID
{
    [appendixData writeToFile:[self pathForAppendix:appendxID] atomically:YES];
}

- (NSString *)pathForAppendix:(NSNumber *)appendxID
{
    return [self fullPathForName:ACCOUNT_APPENDIX_NAME(appendxID)];
}

@end
