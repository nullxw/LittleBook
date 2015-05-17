//
//  LBSearchBar.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBSearchBar.h"
#import <Foundation/Foundation.h>

@implementation LBSearchBar

- (void)awakeFromNib
{
    [self setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
}

@end
