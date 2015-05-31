//
//  LBExportManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/5/17.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Document;

@interface LBExportManager : NSObject

- (void)openDocImage:(UIImage *)image withHolder:(UIViewController *)holder;

+ (void)exportDocument:(Document *)doc asPDF:(UIView *)docView;

- (void)exportToLocal:(UIImage *)image;

@end
