//
//  HPRoundCornerTableView.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPRoundCornerTableView.h"

@implementation HPRoundCornerTableView

- (void)awakeFromNib
{
    self.clipsToBounds = TRUE;
    self.layer.cornerRadius = _cornerRadius > 0 ? _cornerRadius : HP_COMMON_CORNER_RADIUS;
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth >= 0 ? _borderWidth : HP_ONE_PX_SIZE;
}

#ifdef IB_DESIGNABLE
- (void)prepareForInterfaceBuilder
{
    self.clipsToBounds = TRUE;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth;
}
#endif

@end
