//
//  LBTextView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/31.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBTextView.h"

@implementation LBTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentOffset = CGPointMake(0, 0);
}
@end
