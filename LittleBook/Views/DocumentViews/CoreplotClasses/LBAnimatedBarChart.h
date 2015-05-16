//
//  AnimatedBarChat.h
//  CorePlotDemo
//
//  Created by hupeng on 15/3/25.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface LBAnimatedBarChart : CPTGraphHostingView

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) CPTTheme *theme;
@property (nonatomic, assign) NSInteger barCount;
@property (nonatomic, assign) BOOL touchEnable;
@end
