//
//  ImageFilterManager.m
//  ImageFilter
//
//  Created by hupeng on 14-10-11.
//  Copyright (c) 2014年 hupeng. All rights reserved.
//

#import "ImageFilterManager.h"

@interface ImageFilterManager()
{
    dispatch_queue_t _queue;
}
@end

@implementation ImageFilterManager

+ (ImageFilterManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[ImageFilterManager alloc] init]);
}

- (id)init
{
    if (self = [super init]) {
        
        const char *label = [[@"ImageFilterManagerQueue" dataUsingEncoding:NSUTF8StringEncoding] bytes];
        _queue = dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT);
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ILSFilters" ofType:@"plist"];
        _filters = [[NSArray alloc] initWithContentsOfFile:plistPath];

    }
    return self;
}

- (void)applyFilter:(NSInteger)filterIndex
     withInputImage:(UIImage *)inputImage
  completionHandler:(void(^)(UIImage *outputImage))completionHandler
{
    dispatch_async(_queue, ^{
        
        CIImage *outputImage = [self applyFilter:filterIndex withInputUIImage:inputImage];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completionHandler) {
                completionHandler([UIImage imageWithCIImage:outputImage]);
            }
        });
    });
}

- (CIImage *)applyFilter:(NSInteger)filterIndex withInputUIImage:(UIImage *)inputImage
{
    CIImage *_inputImage = inputImage.CIImage ? inputImage.CIImage : [CIImage imageWithCGImage:inputImage.CGImage];
    
    return [self applyFilter:filterIndex withInputCIImage:_inputImage];
}

- (CIImage *)applyFilter:(NSInteger)filterIndex withInputCIImage:(CIImage *)inputImage
{
    if (filterIndex >= [_filters count]) {
        return inputImage;
    }

    NSDictionary *filterInfos = _filters[filterIndex];
    NSArray *filters = filterInfos[@"filters"];
    
    CIImage *outputImage = inputImage;
    
    for (NSDictionary *filterInfo in filters) {
        
        CIFilter *filter = [CIFilter filterWithName:filterInfo[@"CIAttributeFilterName"]];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        
        for (NSString *key in filterInfo.allKeys) {
            
            if ([key isEqualToString:kCIAttributeFilterName]) {
                continue;
            }
            
            id value = filterInfo[key];
            if ([key isEqualToString:@"inputCenter"]) {
                NSDictionary *inputCenter = (NSDictionary *)value;
                value = [CIVector vectorWithX:[inputCenter[@"x"] floatValue] Y:[inputCenter[@"y"] floatValue]];
            }
            if ([key isEqualToString:@"inputColor"]) {
                NSDictionary *inputColor = (NSDictionary *)value;
                value =[CIColor colorWithRed:[inputColor[@"r"] floatValue] green:[inputColor[@"g"] floatValue] blue:[inputColor[@"b"] floatValue] alpha:[inputColor[@"a"] floatValue]];
            }
            
            [filter setValue:value forKey:key];
        }
        outputImage = filter.outputImage;
    }
    return outputImage;
}
@end
