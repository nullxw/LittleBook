//
//  LBAppContext.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBAppSettings;

@interface LBAppContext : NSObject

+ (instancetype)context;

@property (nonatomic, strong) LBAppSettings *settings;

@end

@interface LBAppSettings : NSObject

@end