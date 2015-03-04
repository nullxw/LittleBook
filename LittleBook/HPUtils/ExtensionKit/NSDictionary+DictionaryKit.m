//
//  NSDictionary+DictionaryKit.m
//  snapgrab
//
//  Created by hupeng on 15/2/9.
//  Copyright (c) 2015年 Hu Peng. All rights reserved.
//

#import "NSDictionary+DictionaryKit.h"

@implementation NSDictionary (DictionaryKit)

- (NSString *)toString
{
    NSString *str = [NSString stringWithFormat:@"%@", self];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@";" withString:@","];
    str = [str stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    str = [str stringByReplacingOccurrencesOfString:@",}" withString:@"}"];
    return str;
}
@end
