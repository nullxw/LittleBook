//
//  HPCustomFontManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPCustomFontManager.h"
#import <CoreText/CoreText.h>

@implementation HPCustomFontManager

+ (void)loadFont:(NSString *)filePath
{
    NSData *inData = [NSData dataWithContentsOfFile:filePath];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}
@end
