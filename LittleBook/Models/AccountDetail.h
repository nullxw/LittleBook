//
//  AccountDetail.h
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface AccountDetail : NSManagedObject

@property (nonatomic, retain) NSNumber * accountID;
@property (nonatomic, retain) NSString * parentID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * cost;

@property (nonatomic, strong, readonly) Account *parentAccount;

@end
