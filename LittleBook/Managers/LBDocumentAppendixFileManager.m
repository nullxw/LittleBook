//
//  LBAppendixManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentAppendixFileManager.h"
#import "Appendix.h"

@implementation LBDocumentAppendixFileManager

+ (LBDocumentAppendixFileManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBDocumentAppendixFileManager alloc] init]);
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
