//
//  LBRoundCornerImageView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBRoundCornerImageView.h"

@implementation LBRoundCornerImageView

- (void)awakeFromNib
{
    self.layer.cornerRadius = LB_COMMON_CORNER_RADIUS;
    self.clipsToBounds = TRUE;
}

@end
