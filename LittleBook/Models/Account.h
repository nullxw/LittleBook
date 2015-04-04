//
//  Account.h
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * accountID;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * totalCost;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString *appendixs;

+ (NSString *)generateAccountIDFromDate:(NSDate *)date;

- (void)updateAccountAppendixs:(NSArray *)appendixIDs;

- (NSArray *)appendixIDs;

@end
