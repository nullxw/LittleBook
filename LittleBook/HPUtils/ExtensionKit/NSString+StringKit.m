//
//  StringKit.m
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "NSString+StringKit.h"

@implementation NSString (StringKit)

- (BOOL)isEmpty
{
    if (!self) {
        return YES;
    }
    // check null
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    // filter 回车 换行 空白
    if ([[[[[self stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

@end
