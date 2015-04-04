//
//  LBAppendixManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appendix.h"

@interface LBAppendixManager : NSObject

// Create
+ (Appendix *)createAppendixWithMediaData:(NSData *)data;

// Retrieve
+ (NSArray *)appendixsOfAccountDetail:(NSNumber *)accountID;

+ (Appendix *)findByID:(NSNumber *)appendixID;

+ (NSArray *)findByIDs:(NSArray *)appendixIDs;

@end
