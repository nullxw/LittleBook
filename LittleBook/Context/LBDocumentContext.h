//
//  LBDocumentContext.h
//  LittleBook
//
//  Created by 胡鹏 on 15/5/2.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

typedef enum {
    LBAppendixTypeImage,
    LBAppendixTypeAudio
} LBAppendixType;

#import <Foundation/Foundation.h>

@class Document, Appendix;

@interface LBDocumentContext : NSObject

+ (instancetype)defaultContext;

- (Document *)prepareContext:(Document *)document;

- (void)saveContext;

- (Appendix *)addAppendix:(id)appendix type:(LBAppendixType)type;

@end
