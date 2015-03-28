//
//  NotificationEditCell.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificationEditCell.h"
#import "HPLine.h"

@interface NotificationEditCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet HPLine *seperatorLine;

@end


@implementation NotificationEditCell

- (void)didMoveToSuperview
{
    float h = CGRectGetHeight(self.bounds);
    float w = CGRectGetWidth(self.bounds);
    _switchControl.center = CGPointMake(w - 50, _switchControl.center.y);
    _timeLabel.center = CGPointMake(100, _timeLabel.center.y);
    _seperatorLine.frame = CGRectMake(0, h - 1 , w, LB_ONE_PX_SIZE);
    [self bringSubviewToFront:_seperatorLine];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
