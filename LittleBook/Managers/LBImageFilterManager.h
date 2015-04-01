//
//  LBImageFilterManager.h
//  ImageFilter
//
//  Created by hupeng on 14-10-11.
//  Copyright (c) 2014年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LBImageFilterManager : NSObject

@property (nonatomic, strong) NSArray *filters;

+ (LBImageFilterManager *)defaultManager;

- (void)applyFilter:(NSInteger)filterIndex
     withInputImage:(UIImage *)inputImage
  completionHandler:(void(^)(UIImage *outputImage))completionHandler;

- (CIImage *)applyFilter:(NSInteger)filterIndex
        withInputUIImage:(UIImage *)inputImage;

- (CIImage *)applyFilter:(NSInteger)filterIndex
        withInputCIImage:(CIImage *)inputImage;

@end
