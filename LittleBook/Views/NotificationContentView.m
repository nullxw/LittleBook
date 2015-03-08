//
//  NotificationContentView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificationContentView.h"

@implementation NotificationContentView

- (void)awakeFromNib
{
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = LB_ONE_PX_SIZE;
    self.layer.cornerRadius = 5.0;
}

@end
