//
//  ILS.m
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "UIImage+ImageExt.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (ImageExt)

- (UIImage *)clipToRect:(CGRect)rect
{
    float w = self.size.width;
    float h = self.size.height;

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, w, h)];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}


- (UIImage *)clipToSize:(CGSize)size
{
    return [self clipToSize:size position:ILSImageExtensionImageClipPositionTopLeft];
}

- (UIImage *)clipToSize:(CGSize)size position:(ILSImageExtensionImageClipPosition)position
{
    if (!self) {
        return nil;
    }
    
    float w = self.size.width;
    float h = self.size.height;
    
    BOOL flag = w / size.width > h / size.height;
    
    float dw , dh;
    
    if (flag) {
        
        dh = size.height;
        
        dw = w / h * dh;
    } else {
        
        dw = size.width;
        
        dh = h / w * dw;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    switch (position) {
        case ILSImageExtensionImageClipPositionTopLeft:
            [self drawInRect:CGRectMake(-2, -2, dw + 4, dh + 4)]; // -2 fix bug : iphone 6 6p 图片出现白边
            break;
        case ILSImageExtensionImageClipPositionCenter:
            [self drawInRect:CGRectMake(-(dw - size.width) * 0.5, -(dh - size.height) * 0.5, dw, dh)];
            break;
        default:
            [self drawInRect:CGRectMake(0, 0, dw, dh)];
            break;
    }
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}

- (UIImage *)scaleToSize:(CGSize)size
{
    if (!self) {
        return nil;
    }
    
    float w = self.size.width;
    float h = self.size.height;
    
    BOOL flag = w / size.width > h / size.height;
    
    float dw , dh;
    
    //
    if (flag) {
        
        dw = size.width;
        
        dh = h / w * dw;
        
    } else {
        dh = size.height;
        
        dw = w / h * dh;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(dw, dh), NO, [UIScreen mainScreen].scale);
    
    [self drawInRect:CGRectMake(0, 0, dw, dh)];
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
    
}

- (UIImage *)compositeWithImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    [image drawInRect:CGRectMake((self.size.width - image.size.width) * 0.5, (self.size.height - image.size.height) * 0.5, image.size.width, image.size.height)];
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}

- (CGSize)sizeForContainer:(CGSize)containerSize
{
    float w = self.size.width;
    float h = self.size.height;
    
    
    BOOL flag = w / containerSize.width > h / containerSize.height;
    
    float toW , toH;
    
    if (flag) {
        toW = containerSize.width;
        toH = h / w * toW;
    } else {
        toH = containerSize.height;
        toW = w / h * toH;
    }

    return CGSizeMake(toW, toH);
}

- (UIImage *)rotateImage:(float)angle mirrored:(BOOL)mirrored
{
    CGSize oSize = CGSizeMake(self.size.height, self.size.width);;
    
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oSize.width, oSize.height)];
    
    CGAffineTransform t = CGAffineTransformMakeRotation(angle);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, angle);
    CGContextScaleCTM(bitmap, mirrored ? -1.0 : 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oSize.width / 2, -oSize.height / 2, oSize.width, oSize.height), [self CGImage]);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

@end
