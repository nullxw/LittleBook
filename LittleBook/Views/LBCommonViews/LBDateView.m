//
//  LBDateView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDateView.h"

@interface LBDateView ()

@property (nonatomic, weak) IBOutlet UILabel *yearLabel;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel_CH;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel_EN;

@end

@implementation LBDateView

- (void)awakeFromNib
{
    NSArray *months = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate new]];
    
    _yearLabel.text     = @(comps.year).stringValue;
    _monthLabel_CH.text = [@(comps.month).stringValue stringByAppendingString:@"月"];
    _monthLabel_EN.text = months[comps.month-1];
}

@end
