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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEneterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)setDocument:(Document *)document
{
    _document = document;
    [self cleanContext];
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(autoSave) userInfo:nil repeats:YES];
}

- (Document *)prepareDocument
{
    _document = [LBDocumentManager document];
    
    [self cleanContext];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(autoSave) userInfo:nil repeats:YES];
    
    return self.document;
}

- (void)cleanContext
{
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _document = nil;
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
        [_appendixs addObject:appendix];
        return appendix;
    }
    return nil;

}
#pragma mark- 

- (void)autoSave
{
    __block typeof(self) weakSelf = self;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Document *locDoc = [LBDocumentManager findByID:weakSelf.document.documentID inContext:localContext];
        locDoc.content = weakSelf.document.content;
        locDoc.title   = weakSelf.document.title;
        locDoc.documentSize = weakSelf.document.documentSize;
        
        for (Appendix *appendix in _appendixs) {
            Appendix *localAppendix = [LBAppendixManager findByID:appendix.appendixID inContext:localContext];
            localAppendix.frame = appendix.frame;
        }
        NSLog(@"Auto Saving at time %@", [NSDate date]);
    }];
}

- (void)appDidEneterBackground
{
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)appWillEnterForground
{
    if (self.document && _timer) {
        [_timer fire];
    }
}
@end
