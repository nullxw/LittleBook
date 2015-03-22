//
//  LBAccountTimeLineLabel.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountTimeLineLabel.h"
#import "LunarCalendar.h"

@implementation LBAccountTimeLineLabel

- (void)didMoveToSuperview
{
    if (!self.date) {
        self.date = [NSDate new];
    }
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    LunarCalendar *cal = [date chineseCalendarDate];
    
    NSArray *weekDays = @[@"星期日" ,@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    NSString *text = [NSString stringWithFormat:@"%d月%d日   %@   农历%@%@",[cal GregorianMonth], [cal GregorianDay], weekDays[[cal Weekday] - 1], [cal MonthLunar], [cal DayLunar]];
    self.text = text;
}
@end
