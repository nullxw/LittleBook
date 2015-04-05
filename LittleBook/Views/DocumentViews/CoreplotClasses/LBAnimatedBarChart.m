//
//  AnimatedBarChat.m
//  CorePlotDemo
//
//  Created by hupeng on 15/3/25.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#define LB_BAR_PLOT_ID @"LB_BAR_PLOT_ID"

#import "LBAnimatedBarChart.h"
#import "CPTGraphHostingView+BarPlotExt.h"
#import "LBPresentTheme.h"
#import "LBSimpleTheme.h"


@interface LBAnimatedBarChart ()<CPTPlotDataSource>
{
    CPTXYGraph *_barChart;

    float _maxYRange;
    float _maxXRange;
    float _xMajorTickDistance;
    float _yMajorTickDistance;
    float _yChangeStep;
    int   _yMajorTickCount;
    int   _xMajorTickCount;
    
    NSMutableArray *_barRects;
    NSInteger _selectedIndex;
    CGPoint _startPoint;
    CGFloat _startValue;
    
    NSMutableArray *_dataSource;
}
@end

@implementation LBAnimatedBarChart

- (void)awakeFromNib
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeBarValue:)];
    [self addGestureRecognizer:pan];
}

- (void)setBarCount:(NSInteger)barCount
{
    _barCount = barCount;

    _dataSource = [[NSMutableArray alloc] initWithCapacity:barCount];
    
    for ( int i = 0; i < barCount; i++) {
        [_dataSource addObject:@(50)];
    }
    
    [_barChart reloadData];
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [_barChart reloadData];
}


- (void)setTheme:(CPTTheme *)theme
{
    _theme = theme;
    [self initParams];
    [self initBarChart];
}

- (void)initParams
{
    if (!_dataSource) {
        self.barCount = 5;
    }
    _selectedIndex = -1;
    
    _xMajorTickCount = 10;
    _yMajorTickCount = 5;
    
    _yChangeStep= 100;
    
    _maxYRange = 120;
    _maxXRange = 120;
    
    _xMajorTickDistance = (_maxXRange - 10) / _xMajorTickCount;
    _yMajorTickDistance = (_maxYRange - 10) / _yMajorTickCount;
}

- (void)setupAxis:(CPTXYAxis *)axis withMajorTickLocationsCount:(int)tickCount distance:(float)distance
{
    NSMutableSet *set = [[NSMutableSet alloc] initWithCapacity:tickCount];
    for (int i = 1; i <= tickCount; i++) {
        [set addObject:[NSDecimalNumber numberWithUnsignedInteger:i * distance]];
    }
    axis.majorTickLocations = set;
}

- (CPTFill *)fillColorForTheme:(CPTTheme *)theme
{
    CPTFill *fill = nil;
    if ([theme isKindOfClass:[LBPresentTheme class]]) {
        
        CPTGradient *stocksBackgroundGradient = [[CPTGradient alloc] init];
        
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(63.0/255.0) green:CPTFloat(163.0/255.0) blue:CPTFloat(220.0/255.0) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(0.0)];
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(63.0/255.0) green:CPTFloat(163.0/255.0) blue:CPTFloat(220.0/255.0) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(0.6)];
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(91.0/255.0) green:CPTFloat(179.0/255.0) blue:CPTFloat(227.0/255.0) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(0.6)];
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(91.0/255.0) green:CPTFloat(179.0/255.0) blue:CPTFloat(227.0/255.0) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(0.8)];
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(123.0/255.0) green:CPTFloat(191.0/255.0) blue:CPTFloat(228.0/255.0) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(0.8)];
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(123.0/255.0) green:CPTFloat(191.0/255.0) blue:CPTFloat(228.0/255.0) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(1.0)];
        
        stocksBackgroundGradient.angle = CPTFloat(90.0);
        fill = [CPTFill fillWithGradient:stocksBackgroundGradient];
        
    } else {
        CPTGradient *stocksBackgroundGradient = [[CPTGradient alloc] init];
        
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(0.21569) green:CPTFloat(0.28627) blue:CPTFloat(0.44706) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(0.0)];
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(0.09412) green:CPTFloat(0.17255) blue:CPTFloat(0.36078) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(0.5)];
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(0.05882) green:CPTFloat(0.13333) blue:CPTFloat(0.33333) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(0.5)];
        stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:CPTFloat(0.05882) green:CPTFloat(0.13333) blue:CPTFloat(0.33333) alpha:CPTFloat(1.0)]
                                                               atPosition:CPTFloat(1.0)];
        
        stocksBackgroundGradient.angle = CPTFloat(270.0);
        
        fill = [CPTFill fillWithGradient:stocksBackgroundGradient];
    }
    
    return fill;

}

- (void)initBarChart
{
    self.userInteractionEnabled = TRUE;
    
    _barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    [_barChart applyTheme:_theme];
    self.hostedGraph = _barChart;
    
    // Border
    _barChart.plotAreaFrame.borderLineStyle = nil;
    _barChart.plotAreaFrame.cornerRadius    = 0.0;
    _barChart.plotAreaFrame.masksToBorder   = NO;
    
    // Paddings
    _barChart.paddingLeft   = 0.0;
    _barChart.paddingRight  = 0.0;
    _barChart.paddingTop    = 0.0;
    _barChart.paddingBottom = 0.0;
    
    _barChart.plotAreaFrame.paddingLeft   = 10.0;
    _barChart.plotAreaFrame.paddingTop    = 10.0;
    _barChart.plotAreaFrame.paddingRight  = 10.0;
    _barChart.plotAreaFrame.paddingBottom = 10.0;
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(_maxYRange)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(_maxXRange)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromDouble(_xMajorTickDistance);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    x.labelingPolicy              = CPTAxisLabelingPolicyNone;
    [self setupAxis:x withMajorTickLocationsCount:_xMajorTickCount distance:_xMajorTickDistance];
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromDouble(20.0);
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    y.labelingPolicy              = CPTAxisLabelingPolicyNone;
    [self setupAxis:y withMajorTickLocationsCount:_yMajorTickCount distance:_yMajorTickDistance];
    
    
    
    
    
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor clearColor];
    
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    barPlot.baseValue  = CPTDecimalFromDouble(0.0);
    barPlot.dataSource = self;
    barPlot.identifier = LB_BAR_PLOT_ID;
    barPlot.barWidth = CPTDecimalFromFloat(16.0);
    barPlot.fill = [self fillColorForTheme:_theme];
    barPlot.lineStyle = lineStyle;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [anim setDuration:0.45f];
    anim.toValue = [NSNumber numberWithFloat:1.0f];
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    anim.fillMode = kCAFillModeForwards;
    barPlot.anchorPoint = CGPointMake(0.0, 0.0);
    [barPlot addAnimation:anim forKey:@"grow"];
    
    [_barChart addPlot:barPlot toPlotSpace:plotSpace];
    
}

- (void)changeBarValue:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan && _selectedIndex < 0) {
        
        _barRects = [[NSMutableArray alloc] initWithCapacity:_dataSource.count];
        for (int i = 0; i < _dataSource.count; i++) {
            CGRect rect = [self barFrameAtIndex:i];
            [_barRects addObject:NSStringFromCGRect(rect)];
        }
        
        for (int i = 0; i < _barRects.count; i++) {
            CGRect rect = CGRectFromString(_barRects[i]);
            if (CGRectContainsPoint(rect, point)) {
                _selectedIndex = i;
                _startValue = [_dataSource[i] floatValue];
                _startPoint = point;
                break;
            }
        }
    } else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        _selectedIndex = -1;
        
    } else if (pan.state == UIGestureRecognizerStateChanged && _selectedIndex >= 0) {
        int dValue = _startValue + (_startPoint.y - point.y) * _maxYRange/ (2 * _yChangeStep);
        dValue = MIN(100, dValue);
        _dataSource[_selectedIndex] = @(dValue);
        [_barChart reloadData];
    }
}



#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _dataSource.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation: {
                
                int barDistance = _maxXRange/_dataSource.count;
                
                // 写死的距离。。
                int oX = (int)((5 - _dataSource.count) * 5 + 10);
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index)*barDistance + oX];
                break;
            }
            case CPTBarPlotFieldBarTip:
                num = _dataSource[index];
                break;
        }
    }
    
    return num;
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    NSNumber *tipPoint = _dataSource[idx];
    
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    textStyle.color = [CPTColor whiteColor];
    
    CPTTextLayer *titleLayer = [[CPTTextLayer alloc] initWithText:tipPoint.stringValue style:textStyle];

    return titleLayer;
}

#pragma mark -

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    CPTPlot *piePlot = [_barChart plotWithIdentifier:LB_BAR_PLOT_ID];
    CABasicAnimation *basicAnimation = (CABasicAnimation *)theAnimation;
    [piePlot removeAnimationForKey:basicAnimation.keyPath];
    [piePlot setValue:basicAnimation.toValue forKey:basicAnimation.keyPath];
    [piePlot repositionAllLabelAnnotations];
}

@end
