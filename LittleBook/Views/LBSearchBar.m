//
//  LBSearchBar.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBSearchBar.h"

@implementation LBSearchBar

- (void)awakeFromNib
{
    CGSize size = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,30,30)
                                cornerRadius:5.0] addClip];
    [[UIColor colorWithR:211 g:232 b:242 a:1.0] setFill];
    
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
}

@end
