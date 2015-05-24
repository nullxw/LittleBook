//
//  LBDatePickerCell.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDatePickerCell.h"
#import "LBNotificationManager.h"

@implementation LBDatePickerCell

- (void)awakeFromNib
{
    Notification *notif = [LBNotificationManager defaultManager].preparedEntity;
    _datePicker.minimumDate = [NSDate new];
    _datePicker.date = notif.fireDate;
}


- (IBAction)didSelectDate:(UIDatePicker *)sender
{
    [LBNotificationManager defaultManager].preparedEntity.fireDate = sender.date;
}

@end
