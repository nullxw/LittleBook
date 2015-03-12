//
//  UIView+ImageViewGenerator.m
//  snapgrab
//
//  Created by hupeng on 14-6-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "UIView+ViewKit.h"

@implementation UIView (ViewKit)

- (UIImage *)viewShot
{
    float scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)loadNib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}
@end