//
//  LBFrameView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBFrameView.h"

@implementation LBFrameView

- (void)awakeFromNib
{
    self.layer.cornerRadius = 10;
    self.layer.borderWidth  = LB_ONE_PX_SIZE;
    self.layer.borderColor  = LB_BLUE_LINE_COLOR.CGColor;

}
@end
