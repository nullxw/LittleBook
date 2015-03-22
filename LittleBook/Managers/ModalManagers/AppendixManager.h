//
//  AppendixManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appendix.h"

@interface AppendixManager : NSObject

+ (AppendixManager *)defaultManager;

- (Appendix *)createAppendixWithMediaData:(NSData *)data;

- (NSArray *)appendixOfAccount:(NSNumber *)accountID;

- (Appendix *)findByID:(NSNumber *)appendixID;

@end
