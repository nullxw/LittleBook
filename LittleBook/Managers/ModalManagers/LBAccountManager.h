//
//  LBAccountManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface LBAccountManager : NSObject

+ (LBAccountManager *)defaultManager;

- (Account *)createAccountWithAppendixDatas:(NSArray *)appendixDatas;

- (NSArray *)findAll;

@end
