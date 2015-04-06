//
//  UIView+ImageViewGenerator.h
//  snapgrab
//
//  Created by hupeng on 14-6-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewExt)

- (UIImage *)viewShot;

// coreplot 的特例
- (UIImage *)viewShotForCPView;

+ (instancetype)loadNibForCurrentDevice;

@end
