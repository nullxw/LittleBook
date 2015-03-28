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
@end
