//
//  ImageFilterManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "ImageFilterManager.h"

@implementation ImageFilterManager

+ (instancetype)defaultManager
{
    static ImageFilterManager *_defaultManager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (!_defaultManager) {
            _defaultManager = [[ImageFilterManager alloc] init];
        }
    });
    return _defaultManager;
}

@end
