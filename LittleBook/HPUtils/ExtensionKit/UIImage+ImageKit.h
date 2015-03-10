//
//  ILS.h
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//
typedef enum {
    ILSImageExtensionImageClipPositionCenter,
    ILSImageExtensionImageClipPositionTopLeft,
    ILSImageExtensionImageClipPositionBottonLeft

} ILSImageExtensionImageClipPosition;


#import <UIKit/UIKit.h>

@interface UIImage (ImageKit)

- (UIImage *)clipToRect:(CGRect)rect;

- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleToSize:(CGSize)size position:(ILSImageExtensionImageClipPosition)position;
- (UIImage *)compositeWithImage:(UIImage *)image;

// 不通用的方法！！！
- (UIImage *)rotateImage:(float)angle mirrored:(BOOL)mirrored;

@end