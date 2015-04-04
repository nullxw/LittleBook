//
//  HPCommonFunctions.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/3.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

NSString * getUUID ()
{
    CFUUIDRef udid = CFUUIDCreate(NULL);
    NSString *uuid = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
    CFRelease(udid);
    return uuid;
}

CGSize clipContainerSize(CGSize containerSize , CGSize contentSize)
{
    CGSize newSize = CGSizeZero;
    
    if (containerSize.height/containerSize.width > contentSize.height/contentSize.width) {
        newSize.width  = containerSize.width;
        newSize.height = containerSize.width * contentSize.height/contentSize.width;
    } else {
        newSize.height = containerSize.height;
        newSize.width  = containerSize.height * contentSize.width/contentSize.height;
    }
    return newSize;
}
