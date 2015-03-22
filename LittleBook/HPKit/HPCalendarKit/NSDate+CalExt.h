//
//  NSDate+CalExt.h
//  CalendarView
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 胡鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPMonth : NSObject

// weakDay start from 1 to 7,
// each represent from Monday to Saturday
@property (nonatomic, assign) NSInteger startWeekDay;
@property (nonatomic, assign) NSInteger endWeekDay;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger preMonthLength;
// include premonth's tail and nextmonth's head
@property (nonatomic, assign, readonly) NSInteger fullLength;
@property (nonatomic, retain, readonly) NSArray *fullDays;

// monthIndex start from 1 to 12
+ (HPMonth *)monthAtIndex:(NSInteger)monthIndex;
+ (HPMonth *)monthAtIndex:(NSInteger)monthIndex ofYear:(NSInteger)year;
@end

@interface NSDate (CalExt)

+ (NSInteger)currentWeekDay;
+ (HPMonth *)currentMonth;
+ (NSInteger)currentDay;
- (BOOL)isLeapYear;

@end
