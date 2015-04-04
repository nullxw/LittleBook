//
//  HPRoundCornerButton.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPRoundCornerButton.h"

@implementation HPRoundCornerButton

- (void)awakeFromNib
{
    self.clipsToBounds = TRUE;
    self.layer.cornerRadius = _cornerRadius > 0 ? _cornerRadius : HP_COMMON_CORNER_RADIUS;
}

#ifdef IB_DESIGNABLE
- (void)prepareForInterfaceBuilder
{
    self.clipsToBounds = TRUE;
    self.layer.cornerRadius = _cornerRadius;
}
#endif

@end
