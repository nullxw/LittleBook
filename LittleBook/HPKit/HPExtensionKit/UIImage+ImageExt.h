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

@interface UIImage (ImageExt)

- (UIImage *)clipToRect:(CGRect)rect;

- (UIImage *)clipToSize:(CGSize)size;
- (UIImage *)clipToSize:(CGSize)size position:(ILSImageExtensionImageClipPosition)position;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)compositeWithImage:(UIImage *)image;

// 不通用的方法！！！
- (UIImage *)rotateImage:(float)angle mirrored:(BOOL)mirrored;

@end