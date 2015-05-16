//
//  LBActionSheetCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBActionSheetCell.h"

@implementation LBActionSheetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

     self.backgroundColor = selected ? [UIColor colorWithR:43 g:138 b:212 a:1.0] : [UIColor clearColor];
}

@end
