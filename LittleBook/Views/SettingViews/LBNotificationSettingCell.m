//
//  LBNotificationDotView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/11.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBNotificationSettingCell.h"

@interface LBNotificationSettingCell ()


@end
@implementation LBNotificationSettingCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    float offsetX = 30;
    _descContainer.center = CGPointMake(offsetX + CGRectGetWidth(_descContainer.frame) * 0.5, CGRectGetHeight(self.bounds));
    
    _switchView.center = CGPointMake(CGRectGetWidth(self.bounds) - 50, _descContainer.center.y);
}

@end
