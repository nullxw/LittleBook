//
//  AppendixManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "DocumentAppendixManager.h"
#import "Appendix.h"

@implementation DocumentAppendixManager

+ (DocumentAppendixManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[DocumentAppendixManager alloc] init]);
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
