//
//  LBAccountDetailManager.h
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountDetail.h"

@interface LBAccountDetailManager : NSObject

// Create
+ (AccountDetail *)createAccountWithAppendixDatas:(NSArray *)appendixDatas
                                      description:(NSString *)desc
                                          andCost:(NSNumber *)cost
                                         parentID:(NSString *)parentID;

// Retrieve
+ (NSArray *)findAllOfAccount:(NSString *)parentID;
+ (NSArray *)findAllOfAccount:(NSString *)parentID inContext:(NSManagedObjectContext *)context;

// Delete
+ (void)deleteAccountDetail:(AccountDetail *)accountDetail inContext:(NSManagedObjectContext *)context;
@end
