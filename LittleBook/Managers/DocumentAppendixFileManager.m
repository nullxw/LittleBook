//
//  AppendixManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "DocumentAppendixFileManager.h"
#import "Appendix.h"

@implementation DocumentAppendixFileManager

+ (DocumentAppendixFileManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[DocumentAppendixFileManager alloc] init]);
}

- (NSString *)directory
{
    return @"DocumentAppendix";
}

- (NSSearchPathDirectory)rootDirectory
{
    return NSDocumentDirectory;
}

@end
