//
//  LBMacros.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//
#import "UIColor+ColorExt.h"
#import "CPTColor.h"
#define LB_ONE_PX_SIZE (1.0/[UIScreen mainScreen].scale)

//common params
#define LB_COMMON_CORNER_RADIUS  5.0

#define LB_SPRING_ANIMATION_TIME  0.6
#define LB_LINEAR_ANIMATION_TIME  0.3

// common color
#define LB_LIGHT_GRAY_LINE_COLOR [UIColor colorWithR:246 g:245 b:243 a:1.0]
#define LB_BLUE_LINE_COLOR       [UIColor colorWithR:56 g:162 b:219 a:1.0]
#define LB_CP_BLUE_LINE_COLOR    [CPTColor colorWithComponentRed:0.2190 green:0.6353 blue:0.8588 alpha:1.0]


// notifications

// this notif used between LBImageEditView(receiver) and LBImageFilterView(sender)
#define LB_DID_APPLY_IMAGE_FILTER_NOTIF @"LB_DID_APPLY_IMAGE_FILTER_NOTIF"
