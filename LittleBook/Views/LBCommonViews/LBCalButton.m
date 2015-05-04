//
//  LBCalButton.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/12.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBCalButton.h"

@implementation LBCalButton

- (void)awakeFromNib
{
    [self setTitle:[[NSDate new] formattedString:@"MM dd"] forState:UIControlStateNormal];
}

@end
