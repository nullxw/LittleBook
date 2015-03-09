//
//  LBTableView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/9.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBTableView.h"

@implementation LBTableView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesCancelled:touches withEvent:event];
}

- (void)awakeFromNib
{
    self.scrollEnabled = FALSE;
}

@end
