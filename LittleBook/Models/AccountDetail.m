//
//  AccountDetail.m
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AccountDetail.h"
#import "LBAccountManager.h"

@implementation AccountDetail

@dynamic accountID;
@dynamic parentID;
@dynamic userID;
@dynamic desc;
@dynamic createTime;
@dynamic cost;

- (Account *)parentAccount
{
    return [LBAccountManager findByID:self.parentID];
}

@end
