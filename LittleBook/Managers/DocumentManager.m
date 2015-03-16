//
//  DocumentManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "DocumentManager.h"

@implementation DocumentManager

+ (DocumentManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[DocumentManager alloc] init]);
}

@end
