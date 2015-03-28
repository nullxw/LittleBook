//
//  ILS.m
//  snapgrab
//
//  Created by hupeng on 15-1-15.
//  Copyright (c) 2015年 Hu Peng. All rights reserved.
//

#import "NSData+DataExt.h"

@implementation NSData (DataExt)

- (NSString *)toHexString
{
    NSMutableString *str = [NSMutableString string];
    Byte *byte = (Byte *)[self bytes];
    for (int i = 0; i<[self length]; i++) {
        // byte+i为指针
        [str appendString:[self stringFromByte:*(byte+i)]];
    }
    return str.uppercaseString;
}

- (NSString *)stringFromByte:(Byte)byteVal
{
    NSMutableString *str = [NSMutableString string];
    //取高四位
    Byte byte1 = byteVal>>4;
    //取低四位
    Byte byte2 = byteVal & 0xf;
    //拼接16进制字符串
    [str appendFormat:@"%x",byte1];
    [str appendFormat:@"%x",byte2];
    return str;
}

@end
