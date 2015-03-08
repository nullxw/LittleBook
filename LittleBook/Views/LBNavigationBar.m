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
    self.layer.cornerRadius = 5.0;
    self.layer.borderWidth  = 1.0/[UIScreen mainScreen].scale;
    self.layer.borderColor  = [UIColor colorWithR:220 g:220 b:220 a:1.0].CGColor;
}

@end
