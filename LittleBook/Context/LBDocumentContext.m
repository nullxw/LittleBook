//
//  LBDocumentContext.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/2.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentContext.h"
#import "LBDocumentManager.h"
#import "LBAppendixManager.h"

@interface LBDocumentContext()
{
    NSTimer *_timer;
    Document *_document;
    NSMutableArray *_appendixs;
}
@end

@implementation LBDocumentContext

+ (instancetype)defaultContext
{
    CREATE_SINGLETON_INSTANCE([[LBDocumentContext alloc] init]);
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _appendixs = [[NSMutableArray alloc] initWithCapacity:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEneterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (Document *)prepareContext:(Document *)document
{
    [self saveContext];
    
    if (!document) {
        _document = [LBDocumentManager document];
    } else {
        _document = document;
        _appendixs = [LBAppendixManager appendixs:_document.documentID].mutableCopy;
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(autoSave) userInfo:nil repeats:YES];

    return _document;
}

- (void)saveContext
{
    if (_document.title.length < 1 && _document.content.length < 1 && _appendixs.count == 0) {
        [_document deleteEntity];
    }
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _document = nil;
    
    [_appendixs removeAllObjects];
}

- (Appendix *)addAppendix:(id)appendix type:(LBAppendixType)type
{
//    if ([_appendixs containsObject:appendix]) {
//        return ;
//    }
    if (type == LBAppendixTypeImage) {
        UIImage *image = appendix;
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        
        Appendix *appendix = [LBAppendixManager createAppendixWithMediaData:data];
        appendix.parentID = _document.documentID;
        
        [_appendixs addObject:appendix];
        return appendix;
    }
    return nil;

}
#pragma mark- 

- (void)autoSave
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Document *locDoc = [LBDocumentManager findByID:_document.documentID inContext:localContext];
        locDoc.content = _document.content;
        locDoc.title   = _document.title;
        locDoc.documentSize = _document.documentSize;
        
        for (Appendix *appendix in _appendixs) {
            
            Appendix *localAppendix = [LBAppendixManager findByID:appendix.appendixID inContext:localContext];
            localAppendix.frame = appendix.frame;
        }
    }];
}

#pragma mark - notification handlers

- (void)appDidEneterBackground
{
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)appWillEnterForground
{
    if (_document && _timer) {
        [_timer fire];
    }
}
@end
