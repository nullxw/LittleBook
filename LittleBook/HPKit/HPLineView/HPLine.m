//
//  LBSectionLine.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPLine.h"

@implementation HPLine

+(instancetype)verticalLineWithHeight:(float)height
{
    HPLine *line = [[HPLine alloc] initWithFrame:CGRectMake(0, 0, 1.0/[UIScreen mainScreen].scale, height)];
    return line;
}

+(instancetype)horizontalLineWithWidth:(float)width
{
    HPLine *line = [[HPLine alloc] initWithFrame:CGRectMake(0, 0, width, 1.0/[UIScreen mainScreen].scale)];
    return line;
}

- (void)awakeFromNib
{
    float w  = CGRectGetWidth(self.bounds);
    float h  = CGRectGetHeight(self.bounds);
    float oX = CGRectGetMinX(self.frame);
    float oY = CGRectGetMinY(self.frame);
    if (w > h) {
        self.frame = CGRectMake(oX, oY, w, 1.0/[UIScreen mainScreen].scale);
    } else {
        self.frame = CGRectMake(oX, oY, 1.0/[UIScreen mainScreen].scale, h);
    }
}

@end
