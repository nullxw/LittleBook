//
//  AccountAppendixManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AccountAppendixManager.h"

@implementation AccountAppendixManager

+ (AccountAppendixManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[AccountAppendixManager alloc] init]);
}

- (NSString *)directory
{
    return @"AccountAppendix";
}

- (NSSearchPathDirectory)rootDirectory
{
    return NSDocumentDirectory;
}
@end
