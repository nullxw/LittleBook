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
#define LB_LINEAR_ANIMATION_TIME  0.25

typedef enum {
    LBAppendixTypeImage,
    LBAppendixTypeAudio
} LBAppendixType;

// common color
#define LB_LIGHT_GRAY_LINE_COLOR [UIColor colorWithR:246 g:245 b:243 a:1.0]
#define LB_BLUE_LINE_COLOR       [UIColor colorWithR:56 g:162 b:219 a:1.0]
#define LB_CP_BLUE_LINE_COLOR    [CPTColor colorWithComponentRed:0.2190 green:0.6353 blue:0.8588 alpha:1.0]

// TASK KEYS
#define LB_DEFAULT_USER                @"LB_DEFAULT_USER"
#define LB_GUIDE_TASK_KEY              @"LB_GUIDE_TASK_KEY"
#define LB_GUIDE_FILE_IMPORT_TASK_KEY  @"LB_GUIDE_FILE_IMPORT_TASK_KEY"

// notifications

// this notif used between LBImageEditView(receiver) and LBImageFilterView(sender)
//#define LB_DID_APPLY_IMAGE_FILTER_NOTIF @"LB_DID_APPLY_IMAGE_FILTER_NOTIF"
//#define LB_INSERT_IMAGE_NOTIF           @"LB_INSERT_IMAGE_NOTIF"

#define LB_ACTION_TYPE_KEY @"actiontype"
#define LB_ACTION_NOTIF    @"LB_ACTION_NOTIF"

typedef enum {
    LBActionTypeSaveAsDoc,
    LBActionTypeSaveToLocal,
    LBActionTypeSaveAsPDF,
    LBActionTypeOpenIn,
    LBActionTypeInsertAppendix,
    LBActionTypeApplyFilter
} LBActionType;
