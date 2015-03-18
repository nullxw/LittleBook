//
//  IndexInfoManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexInfoManager : NSObject

+ (IndexInfoManager *)defaultManager;

- (NSNumber *)getAppendixID;
- (NSNumber *)getDocumentID;

@end
