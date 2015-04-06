//
//  LBChartView.m
//  LittleBook
//
//  Created by hupeng on 15/4/5.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBChartView.h"
#import "LBChartEditView.h"

@implementation LBChartView

- (void)awakeFromNib
{
    [super awakeFromNib];
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openChartEditView)];
    [self addGestureRecognizer:tap];

}

- (void)didMoveToSuperview
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBarChart:) name:LB_DID_SET_CHART_NOTIF object:nil];
}

- (void)openChartEditView
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    LBChartEditView *chartEditView = [LBChartEditView loadNibForCurrentDevice];
    chartEditView.chartInfo = @{@"barCount" : @(self.barCount),
                                @"theme"    : self.theme,
                                @"dataSource" : self.dataSource};
    chartEditView.frame = win.bounds;
    [win addSubview:chartEditView];
}

- (void)updateBarChart:(NSNotification *)notif
{
    NSDictionary *chartInfo = notif.object;
    self.barCount   = [chartInfo[@"barCount"] intValue];
    self.dataSource = chartInfo[@"dataSource"];
    self.theme      = chartInfo[@"theme"];
}

@end
