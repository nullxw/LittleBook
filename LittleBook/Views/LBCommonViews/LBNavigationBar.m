//
//  LBNavigationBar.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBNavigationBar.h"

@implementation LBNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderWidth  = LB_ONE_PX_SIZE;
    self.layer.borderColor  = [UIColor colorWithR:220 g:220 b:220 a:1.0].CGColor;
}

#ifdef IB_DESIGNABLE
- (void)prepareForInterfaceBuilder
{
    [super prepareForInterfaceBuilder];
    self.layer.borderWidth  = _borderWidth;
    self.layer.borderColor  = _borderColor.CGColor;
}
#endif

@end
