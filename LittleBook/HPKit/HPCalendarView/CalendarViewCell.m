//
//  CalendarViewCell.m
//  CalendarView
//
//  Created by hupeng on 15/3/24.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "CalendarViewCell.h"

@implementation CalendarViewCell

- (void)setIsCurrentDay:(BOOL)isCurrentDay
{
    _isCurrentDay = isCurrentDay;
    _label.layer.cornerRadius = isCurrentDay ? CGRectGetWidth(_label.frame) * 0.5 : 0;
    _label.clipsToBounds = TRUE;
    _label.backgroundColor = isCurrentDay ? [UIColor colorWithR:71 g:166 b:223 a:1.0] : [UIColor clearColor];
    
    if (isCurrentDay) {
        _label.textColor = [UIColor whiteColor];
    } else {
        _label.textColor = _isCurrentMonth ? [UIColor colorWithWhite:0.2 alpha:1.0] : [UIColor colorWithWhite:0.8 alpha:1.0];
    }
}

- (void)setIsCurrentMonth:(BOOL)isCurrentMonth
{
    _isCurrentMonth = isCurrentMonth;
    _label.textColor = isCurrentMonth ? [UIColor colorWithWhite:0.2 alpha:1.0] : [UIColor colorWithWhite:0.8 alpha:1.0];
}

- (void)setIsHoliday:(BOOL)isHoliday
{
    _isHoliday = isHoliday;
    
    if (isHoliday) {
        _label.textColor = _isCurrentMonth ? [UIColor colorWithR:236 g:0 b:14 a:1] : [UIColor colorWithR:255 g:119 b:124 a:1.0];
    } 
}
@end
