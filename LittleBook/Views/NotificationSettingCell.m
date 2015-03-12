//
//  NotificationSettingCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/11.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificationSettingCell.h"

@interface NotificationSettingCell ()


@end
@implementation NotificationSettingCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    float offsetX = 30;
    _descContainer.center = CGPointMake(offsetX + CGRectGetWidth(_descContainer.frame) * 0.5, CGRectGetHeight(self.bounds));
    
    _switchView.center = CGPointMake(CGRectGetMaxX(_descContainer.frame) + 100, _descContainer.center.y);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
