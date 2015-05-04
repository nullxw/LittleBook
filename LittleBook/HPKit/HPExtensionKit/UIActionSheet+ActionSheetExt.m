
//
//  UIActionSheet+ActionSheetExt.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/28.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "UIActionSheet+ActionSheetExt.h"

@implementation UIActionSheet (actionSheetExt)

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hide
{
    [self dismissWithClickedButtonIndex:[self cancelButtonIndex] animated:FALSE];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setAutoHideWhenAppEnterBackground
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
@end
