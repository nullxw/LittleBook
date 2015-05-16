//
//  LBReadFileManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/5/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadFile.h"

@class Document;

@interface LBReadFileManager : NSObject

// Create
+ (ReadFile *)createReadFileFromDocument:(Document *)doc;

// Retrieve
+ (NSArray *)findAll;

// Delete

+ (void)deleteReadFile:(ReadFile *)file;

@end
