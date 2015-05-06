//
//  LBDocumentManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Document.h"

@interface LBDocumentManager : NSObject

// Create
+ (Document *)document;

// Retrieve
+ (Document *)findByID:(NSNumber *)docID inContext:(NSManagedObjectContext*)context;
+ (Document *)findByID:(NSNumber *)docID;

+ (NSArray *)findAll;

// Delete

+ (void)deleteDocument:(Document *)document;

@end
