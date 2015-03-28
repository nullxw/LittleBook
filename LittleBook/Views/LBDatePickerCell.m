//
//  LBDatePickerCell.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDatePickerCell.h"

@implementation LBDatePickerCell

- (void)awakeFromNib
{
    NSDate *now = [NSDate new];
    [_datePicker setDate:now];
    _datePicker.minimumDate = now;
}


@end
