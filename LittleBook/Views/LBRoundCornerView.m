//
//  LBRoundCornerView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBRoundCornerView.h"

@implementation LBRoundCornerView

- (void)awakeFromNib
{
    self.layer.cornerRadius = LB_COMMON_CORNER_RADIUS;
}

@end
