//
//  HPHolidayManager.m
//  LittleBook
//
//  Created by hupeng on 15/4/1.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPHolidayManager.h"

@interface HPHolidayManager ()
{
    NSMutableArray *_holidayInfos;
}
@end

@implementation HPHolidayManager

- (instancetype)init
{
    if (self = [super init]) {
         NSArray *infos = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HolidayInfos_2015" ofType:@"plist"]];
        
        _holidayInfos = [[NSMutableArray alloc] initWithCapacity:infos.count];
        
        
        for (NSDictionary *info in infos) {
            NSString *periodString = info[@"date"];
            NSArray *dates = [periodString componentsSeparatedByString:@"~"];
            NSDate *fromDate = [dates.firstObject dateFromPattern:@"yyyy-MM-dd"];
            NSDate *toDate = [dates.lastObject dateFromPattern:@"yyyy-MM-dd"];
            [_holidayInfos addObject:@{@"from":fromDate,
                                       @"to"  :toDate}];
        }
        
    }
    return self;
}

- (BOOL)dateIsHoliday:(NSDate *)date
{
    for (NSDictionary *holidayInfo in _holidayInfos) {
        
        if ([date betweenDate:holidayInfo[@"from"] toDate:holidayInfo[@"to"]]) {
            return TRUE;
        }
    }
    return FALSE;
}

@end
