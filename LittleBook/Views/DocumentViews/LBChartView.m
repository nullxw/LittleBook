//
//  LBChartView.m
//  LittleBook
//
//  Created by hupeng on 15/4/5.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBChartView.h"
#import "LBChartEditView.h"

@interface LBChartView () <LBChartEditViewDelegate>

@end
@implementation LBChartView

- (void)awakeFromNib
{
    [super awakeFromNib];
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openChartEditView)];
    [self addGestureRecognizer:tap];
}

- (void)openChartEditView
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    LBChartEditView *chartEditView = [LBChartEditView loadNibForCurrentDevice];
    chartEditView.chartInfo = @{@"barCount" : @(self.barCount),
                                @"theme"    : self.theme,
                                @"dataSource" : self.dataSource};
    chartEditView.frame = win.bounds;
    chartEditView.delegate = self;
    [win addSubview:chartEditView];
}

#pragma mark - LBChartEditViewDelegate

- (void)didUpdateChartInfo:(NSDictionary *)chartInfo
{
    self.barCount   = [chartInfo[@"barCount"] intValue];
    self.dataSource = chartInfo[@"dataSource"];
    self.theme      = chartInfo[@"theme"];
}

@end
