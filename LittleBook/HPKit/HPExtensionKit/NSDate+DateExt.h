//
//  ILS.h
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (DateExt)

- (BOOL)inSameWeek:(NSDate *)date;

- (NSInteger)getWeekIndex;

- (NSInteger)getDateComponent:(NSCalendarUnit)calUnit;

// pattern like @"yyyy-MM-dd'T'HH:mm:ss"
- (NSString *)formattedString:(NSString *)pattern;

- (BOOL)betweenDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
