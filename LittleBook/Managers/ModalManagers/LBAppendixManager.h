//
//  LBAppendixManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appendix.h"

@interface LBAppendixManager : NSObject

// Create
+ (Appendix *)createAppendixWithMediaData:(NSData *)data;
+ (Appendix *)createAudioAppendixWithFilePath:(NSString *)filePath andDuration:(int)duration;

// Retrieve
+ (NSArray *)appendixs:(NSNumber *)parentID;
+ (NSArray *)appendixs:(NSNumber *)parentID inContext:(NSManagedObjectContext *)context;

+ (Appendix *)findByID:(NSNumber *)appendixID;
+ (Appendix *)findByID:(NSNumber *)appendixID inContext:(NSManagedObjectContext *)context;

+ (NSArray *)findByIDs:(NSArray *)appendixIDs;

+ (Appendix *)thumbnailAppendixOf:(NSNumber *)documentID;

// Delete
+ (void)deleteAppendixs:(NSNumber *)parentID inContext:(NSManagedObjectContext *)context;
+ (void)deleteAppendix:(Appendix *)appendix;

@end
