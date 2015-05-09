//
//  ILSPPBuildInTimeSystem.m
//  TimeDemo
//
//  Created by hupeng on 15/5/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#define ILSPP_SYSTEMDATE_SERVICE @"ILSPP_SYSTEMDATE_SERVICE"
#define ILSPP_MEIDADATE_SERVICE  @"ILSPP_MEIDADATE_SERVICE"
#define ILSPP_BUILD_IN_TIME_SYSTEM_ACCOUNT @"ILSPP_BUILD_IN_TIME_SYSTEM_ACCOUNT"

#import "HPPPBuildInTimeSystem.h"
#import "HPCommonMacro.h"
#import "SSKeychain.h"

@interface HPPPBuildInTimeSystem ()
{
    NSDateFormatter *_formatter;
}
@end

@implementation HPPPBuildInTimeSystem

+ (instancetype)defaultTimeSystem
{
    CREATE_SINGLETON_INSTANCE([[HPPPBuildInTimeSystem alloc] init]);
}

- (instancetype)init
{
    if (self = [super init]) {
        // It also is called at midnight or at DST changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemTimeChanged:) name:UIApplicationSignificantTimeChangeNotification object:nil];
        
        [self verifyRefrenceDateAndMediaDate];
        
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"";
        
    }
    return self;
}

#pragma mark - notifications

- (void)systemTimeChanged:(NSNotification *)notif
{
    // 纠正 参照时间
    [self verifyRefrenceDate];
}

#pragma mark - private mthods

- (NSDate *)refrenceDate
{
    NSString *sDate = [SSKeychain passwordForService:ILSPP_SYSTEMDATE_SERVICE
                                             account:ILSPP_BUILD_IN_TIME_SYSTEM_ACCOUNT];
    
    return [_formatter dateFromString:sDate];
}

- (CFTimeInterval)refrenceMediaTime
{
    return [[SSKeychain passwordForService:ILSPP_MEIDADATE_SERVICE
                                   account:ILSPP_BUILD_IN_TIME_SYSTEM_ACCOUNT] doubleValue];
}

- (void)setRefrenceDate:(NSDate *)refrenceDate
{
    [SSKeychain setPassword:[_formatter stringFromDate:refrenceDate]
                 forService:ILSPP_SYSTEMDATE_SERVICE
                    account:ILSPP_BUILD_IN_TIME_SYSTEM_ACCOUNT];
}

- (void)setRefrenceMediaTime:(CFTimeInterval)refrenceMediaTime
{
    [SSKeychain setPassword:@(refrenceMediaTime).stringValue
                 forService:ILSPP_MEIDADATE_SERVICE
                    account:ILSPP_BUILD_IN_TIME_SYSTEM_ACCOUNT];
}

// 不可避免的 漏洞
// 修改时间后重启设备
// 必须通过网络来校验正确的时间

- (void)verifyRefrenceDateAndMediaDate
{
    NSDate *refrenceDate = [self refrenceDate];
    CFTimeInterval refrenceMediaTime = [self refrenceMediaTime];
    NSDate *currentDate = [NSDate date];
    CFTimeInterval currentMediaTime = CACurrentMediaTime();

    NSTimeInterval systemDateTimeInterval = [currentDate timeIntervalSinceDate:refrenceDate];
    CFTimeInterval mediaTimeTimeInterval = currentMediaTime - refrenceMediaTime;
    
    if (fabs(systemDateTimeInterval - mediaTimeTimeInterval) < 1.0) {
        return;
    }
    // one refrence date has been modified
    
    // system has been rebooted
    if (mediaTimeTimeInterval < 0 ) {
        [self verifyRefrenceMediaTime];
        return;
    }
    
    [self verifyRefrenceDate];
}

- (void)verifyRefrenceMediaTime
{
    NSDate *refrenceDate = [self refrenceDate];
    
    NSDate *currentDate = [NSDate date];
    CFTimeInterval currentMediaTime = CACurrentMediaTime();
    NSTimeInterval systemDateTimeInterval = [currentDate timeIntervalSinceDate:refrenceDate];
    CFTimeInterval newRefrenceMedia = currentMediaTime - systemDateTimeInterval;
    
    [self setRefrenceMediaTime:newRefrenceMedia];
}

- (void)verifyRefrenceDate
{
    CFTimeInterval refrenceMediaTime = [self refrenceMediaTime];
    CFTimeInterval currentMediaTime = CACurrentMediaTime();
    CFTimeInterval mediaTimeTimeInterval = refrenceMediaTime - currentMediaTime;
    NSDate *newRefrenceDate = [NSDate dateWithTimeIntervalSinceNow:mediaTimeTimeInterval];
    
    [self setRefrenceDate:newRefrenceDate];
}

#pragma mark - public methods

- (void)setCurrentTimeAsRefrenceTime
{
    [self setRefrenceDate:[NSDate date]];
    [self setRefrenceMediaTime:CACurrentMediaTime()];
}

- (void)setAbsoluteRefrenceDate:(NSDate *)date
{
    [self setRefrenceDate:date];
    [self setRefrenceMediaTime:CACurrentMediaTime()];
}

@end
