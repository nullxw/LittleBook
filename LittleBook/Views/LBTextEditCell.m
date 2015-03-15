//
//  LBTextEditCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBTextEditCell.h"

@implementation LBTextEditCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    _iconView.center = CGPointMake(CGRectGetMaxX(self.bounds) - 30, _iconView.center.y);
    
}

@end
