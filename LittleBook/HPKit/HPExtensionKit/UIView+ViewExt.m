//
//  UIView+ImageViewGenerator.m
//  snapgrab
//
//  Created by hupeng on 14-6-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "UIView+ViewExt.h"

@implementation UIView (ViewExt)

- (UIImage *)viewShot
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)viewShotForCPView
{

    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    if (self.layer.sublayers) {
        
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        for (CALayer * layer in self.layer.sublayers) {
            [layer renderInContext:context];
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (instancetype)loadNibForCurrentDevice
{
    NSString *nibName = NSStringFromClass([self class]);
    
    int width = CGRectGetWidth([UIScreen mainScreen].bounds);
    int height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    NSString *preferNibName = [NSString stringWithFormat:@"%@_%d_%d", nibName, width, height];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:preferNibName ofType:@"nib"];
    
    if (filePath) {
        nibName = preferNibName;
    } else {
        preferNibName = [NSString stringWithFormat:@"%@_%d", nibName, width];
        filePath = [[NSBundle mainBundle] pathForResource:preferNibName ofType:@"nib"];
        
        if (filePath) {
            nibName = preferNibName;
        }
    }
    return [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil][0];
}
@end