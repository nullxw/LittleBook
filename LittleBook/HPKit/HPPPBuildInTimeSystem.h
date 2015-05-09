//
//  ILSPPBuildInTimeSystem.h
//  TimeDemo
//
//  Created by hupeng on 15/5/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPPPBuildInTimeSystem : NSObject

@property (nonatomic, strong) NSDate *refrenceDate;

+ (instancetype)defaultTimeSystem;

- (void)setCurrentTimeAsRefrenceTime;

// maybe from a time server
- (void)setAbsoluteRefrenceDate:(NSDate *)date;

@end
