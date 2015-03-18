//
//  AccountAppendixManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPFileSystem.h"

@interface AccountAppendixManager : HPFileSystem

+ (AccountAppendixManager *)defaultManager;

@end
