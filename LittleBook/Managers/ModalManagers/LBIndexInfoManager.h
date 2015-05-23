//
//  LBIndexInfoManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBIndexInfoManager : NSObject

+ (LBIndexInfoManager *)defaultManager;

- (NSNumber *)getAppendixID;
- (NSNumber *)getNotificationID;

// 共用maxAppendixParentID
// 避免appendix 检索冲突
- (NSNumber *)getDocumentID;
- (NSNumber *)getAccountDetailID;

@end
