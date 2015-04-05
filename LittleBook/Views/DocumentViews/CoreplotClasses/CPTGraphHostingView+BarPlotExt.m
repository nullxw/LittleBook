//
//  CPTBarPlot+BarPlotExt.m
//  CorePlotDemo
//
//  Created by hupeng on 15/3/26.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "CPTGraphHostingView+BarPlotExt.h"
#import "CPTPlotSpaceAnnotation.h"
#import "CPTMutableNumericData.h"
#import "CPTMutablePlotRange.h"
#import "CPTPathExtensions.h"
#import "CPTPlotAreaFrame.h"
#import "CPTXYPlotSpace.h"
#import "CPTUtilities.h"
#import "CPTPlotArea.h"
#import "CPTBarPlot.h"

@implementation CPTGraphHostingView (BarPlotExt)

- (CGRect)barFrameAtIndex:(NSInteger)index
{
    CGRect barRect = CGRectZero;

    float plotAreaWidth = CGRectGetWidth(self.bounds);
    float plotAreaHeight = CGRectGetHeight(self.bounds);
    
    plotAreaWidth = plotAreaWidth - self.hostedGraph.paddingLeft - self.hostedGraph.paddingRight - self.hostedGraph.plotAreaFrame.paddingLeft - self.hostedGraph.plotAreaFrame.paddingRight;
    plotAreaHeight = plotAreaHeight - self.hostedGraph.paddingTop - self.hostedGraph.paddingBottom - self.hostedGraph.plotAreaFrame.paddingTop - self.hostedGraph.plotAreaFrame.paddingBottom;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.hostedGraph.defaultPlotSpace;
    
    float unitWidth = plotAreaWidth/[NSDecimalNumber decimalNumberWithDecimal:plotSpace.xRange.length].floatValue;
    
    float unitHeight = plotAreaHeight/[NSDecimalNumber decimalNumberWithDecimal:plotSpace.yRange.length].floatValue;
    
    
    CPTBarPlot *barPlot = (CPTBarPlot *)[self.hostedGraph plotAtIndex:0];
    
    NSNumber *locPoint = [barPlot.dataSource numberForPlot:barPlot field:CPTBarPlotFieldBarLocation recordIndex:index];
    NSNumber *tipPoint = [barPlot.dataSource numberForPlot:barPlot field:CPTBarPlotFieldBarTip recordIndex:index];
    
    NSNumber *barWidth = [NSDecimalNumber decimalNumberWithDecimal:barPlot.barWidth];
    
    barRect.origin.x = (locPoint.floatValue - barWidth.floatValue * 0.5 - [NSDecimalNumber decimalNumberWithDecimal:plotSpace.xRange.location].floatValue) * unitWidth + self.hostedGraph.paddingLeft + self.hostedGraph.plotAreaFrame.paddingLeft;
    
    barRect.size.width = barWidth.floatValue * unitWidth;
    
    barRect.origin.y = self.hostedGraph.paddingTop + self.hostedGraph.plotAreaFrame.paddingTop + ([NSDecimalNumber decimalNumberWithDecimal:plotSpace.yRange.length].floatValue - tipPoint.floatValue + [NSDecimalNumber decimalNumberWithDecimal:plotSpace.yRange.location].floatValue) * unitHeight;
    
    barRect.size.height = tipPoint.floatValue * unitHeight;
    
    return barRect;
}
@end
