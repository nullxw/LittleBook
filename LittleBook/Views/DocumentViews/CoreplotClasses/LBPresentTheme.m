//
//  LBPresentTheme.m
//  CorePlotDemo
//
//  Created by hupeng on 15/3/25.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

NSString *const kCPTLBPresentTheme = @"Little Book Style For Presnet";


#import "LBPresentTheme.h"
#import "CPTMutableLineStyle.h"
#import "CPTXYAxisSet.h"
#import "CPTXYGraph.h"
#import "CPTAxisSet.h"
#import "CPTXYAxis.h"
#import "CPTColor.h"
#import "CPTFill.h"

@implementation LBPresentTheme

+(void)load
{
    [self registerTheme:self];
}

+(NSString *)name
{
    return kCPTLBPresentTheme;
}

#pragma mark -

-(void)applyThemeToBackground:(CPTGraph *)graph
{
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
}

-(void)applyThemeToPlotArea:(CPTPlotAreaFrame *)plotAreaFrame
{

}

-(void)applyThemeToAxisSet:(CPTAxisSet *)axisSet
{
    if ([axisSet isKindOfClass:[CPTXYAxisSet class]]) {
        CPTMutableLineStyle *axisLineStyle = [[CPTMutableLineStyle alloc] init];
        CPTMutableLineStyle *gridLineStyle = [[CPTMutableLineStyle alloc] init];
        axisLineStyle.lineColor = LB_CP_BLUE_LINE_COLOR;
        axisLineStyle.lineWidth = 1.0;
        
        gridLineStyle.lineColor = LB_CP_BLUE_LINE_COLOR;
        gridLineStyle.lineWidth = 1.0f/[UIScreen mainScreen].scale;
        gridLineStyle.dashPattern=[NSArray arrayWithObjects:@3,
                                   @1,
                                   nil];
        
        CPTXYAxis *x = ((CPTXYAxisSet *)axisSet).xAxis;
        x.axisLineStyle               = axisLineStyle;
        x.majorTickLineStyle          = nil;
        x.minorTickLineStyle          = nil;
        x.majorGridLineStyle          = gridLineStyle;
        
        CPTXYAxis *y = ((CPTXYAxisSet *)axisSet).yAxis;
        y.axisLineStyle               = axisLineStyle;
        y.majorTickLineStyle          = nil;
        y.minorTickLineStyle          = nil;
        y.majorGridLineStyle          = gridLineStyle;
    }
}
@end
