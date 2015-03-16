//
//  AppendixFileManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AppendixFileManager.h"

@implementation AppendixFileManager

+ (AppendixFileManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[AppendixFileManager alloc] init]);
}

- (NSString *)directory
{
    return @"LBAppendixs";
}

- (NSSearchPathDirectory)rootDirectory
{
    return NSDocumentDirectory;
}

@end
