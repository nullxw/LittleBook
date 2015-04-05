//
//  LBEditMenuCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBEditMenuCell.h"

@implementation LBEditMenuCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    _iconView.center = CGPointMake(CGRectGetMaxX(self.bounds) - 30, _iconView.center.y);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.backgroundColor = selected ? [UIColor colorWithR:43 g:138 b:212 a:1.0] : [UIColor colorWithR:68 g:184 b:235 a:1.0];
}

@end
