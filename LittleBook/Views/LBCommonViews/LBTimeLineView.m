//
//  LBTimeLineView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBTimeLineView.h"
#import "LunarCalendar.h"

@interface LBTimeLineView ()

@property (nonatomic, weak) IBOutlet UILabel *leftLabel;
@property (nonatomic, weak) IBOutlet UILabel *centerLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;
@end

@implementation LBTimeLineView

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
    
    _leftLabel.text   = [NSString stringWithFormat:@"%d月%d日", [cal GregorianMonth], [cal GregorianDay]];
    _centerLabel.text = weekDays[[cal Weekday] - 1];
    _rightLabel.text  = [NSString stringWithFormat:@"农历%@%@", [cal MonthLunar] ,[cal DayLunar]];
}
@end
