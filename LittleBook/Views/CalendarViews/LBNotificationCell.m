//
//  LBNotificationCell.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBNotificationCell.h"
#import "LBNotificationManager.h"
#import "NSDate+DateExt.h"
#import "Notification.h"
#import "HPLine.h"

@interface LBNotificationCell ()
{
    Notification *_notification;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet HPLine *seperatorLine;

@end


@implementation LBNotificationCell

- (void)didMoveToSuperview
{
    float h = CGRectGetHeight(self.bounds);
    float w = CGRectGetWidth(self.bounds);
    _switchControl.center = CGPointMake(w - 50, _switchControl.center.y);
    _timeLabel.center = CGPointMake(100, _timeLabel.center.y);
    _seperatorLine.frame = CGRectMake(0, h - 1 , w, LB_ONE_PX_SIZE);
    [self bringSubviewToFront:_seperatorLine];
}


- (void)setupWithNotification:(Notification *)notification
{
    _notification = notification;
    _timeLabel.text = [notification.fireDate formattedString:@"HH:mm"];
    _switchControl.on = notification.on.boolValue;
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    _notification.on = @(sender.on);
    [[LBNotificationManager defaultManager] updateLocalNotification:_notification];
}
@end
