//
//  CustomSettingHeaderView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/12.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "CustomSettingHeaderView.h"

@implementation CustomSettingHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = LB_COMMON_CORNER_RADIUS;
    self.layer.borderWidth  = LB_ONE_PX_SIZE * 2;
    self.layer.borderColor  = [UIColor colorWithR:220 g:220 b:220 a:1.0].CGColor;

}
@end
