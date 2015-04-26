//
//  LBChartView.m
//  LittleBook
//
//  Created by hupeng on 15/4/5.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBChartView.h"
#import "LBChartEditView.h"
#import "HPDragContainer.h"
@interface LBChartView () <LBChartEditViewDelegate, HPDragContainerResourceDelegate>
{
    HPDragContainer *_canvas;
}
@end
@implementation LBChartView

- (void)awakeFromNib
{
    [super awakeFromNib];
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openChartEditView)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(openCanvas:)];
    [self addGestureRecognizer:longPress];
    
    
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

- (void)openCanvas:(UILongPressGestureRecognizer *)gesture
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        self.hidden = TRUE;
        
        _canvas = [HPDragContainer shareContainer];
        _canvas.resourceDelegate = self;
        [_canvas show];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        [_canvas updateItemAtPoint:[gesture locationInView:keyWindow]];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        [_canvas hide];
        _canvas = nil;
    }
}

#pragma mark - LBChartEditViewDelegate

- (void)didUpdateChartInfo:(NSDictionary *)chartInfo
{
    self.barCount   = [chartInfo[@"barCount"] intValue];
    self.dataSource = chartInfo[@"dataSource"];
    self.theme      = chartInfo[@"theme"];
}

#pragma mark - HPDragContainerResourceDelegate

- (UIView *)setupItemOfContainer:(HPDragContainer *)container
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    CGRect rect   = [win convertRect:self.frame fromView:self.superview];
    CGPoint point = [win convertPoint:self.center fromView:self.superview];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image  = [self viewShotForCPView];
    imageView.center = point;
    return imageView;
}

- (void)containerWillDismiss:(HPDragContainer *)container withDraggedItemBack:(BOOL)flag
{
    self.hidden = FALSE;
}
@end
