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

- (void)openDoc:(Document *)doc withHolder:(UIViewController *)holder;

+ (void)exportAsPDF:(Document *)doc withCompletionBlock:(void(^)())block;

- (void)exportToLocal:(Document *)doc withCompletionBlock:(void(^)())block;
@end
