//
//  AppendixManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AppendixManager.h"
#import "Appendix.h"

@implementation AppendixManager

+ (AppendixManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[AppendixManager alloc] init]);
}

@end
