//
//  StringKit.m
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "NSString+StringExt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (StringExt)

- (BOOL)isEmpty
{
    // check nil
    if (!self) {
        return YES;
    }
    // check null
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (self.length == 0) {
        return YES;
    }
    
    // filter 回车 换行 空白
    if ([[[[[self stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}


- (NSString*)toHexString:(unsigned char*)data length:(unsigned int)length
{
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return hash;
}

- (NSDate *)dateFromPattern:(NSString *)pattern
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = pattern;
    return [formatter dateFromString:self];
}

- (NSString *)truncateNewLine
{
    NSArray *components = [self componentsSeparatedByString:@"\n"];

    NSString *toStr = @"";
    
    for(NSString *component in components) {
    
        if ([component isEqual:@""]) {
            continue;
        }
        toStr = [toStr stringByAppendingString:component];
        toStr = [toStr stringByAppendingString:@"\n"];
    }
    return toStr;
}

@end

@implementation NSString (Encrypt)

- (NSString*)MD5
{
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_MD5(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];;
}

- (NSString*)SHA1
{
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA1(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];;
}

- (NSString*)SHA256
{
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];;
}

- (unsigned int)UTF8Length
{
    return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

@end
