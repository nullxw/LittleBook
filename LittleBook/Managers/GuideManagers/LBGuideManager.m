//
//  LBGuideManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/6/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBGuideManager.h"
#import "LBReadFileFileManager.h"
#import "LBAppendixFileManager.h"
#import "LBIndexInfoManager.h"
#import "Appendix.h"
#import "ReadFile.h"

@interface LBGuideManager ()
{
    NSArray *_guideInfos;
}
@end

@implementation LBGuideManager

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString *infoPath = [[NSBundle mainBundle] pathForResource:@"GuideInfos" ofType:@"plist"];
        _guideInfos = [NSArray arrayWithContentsOfFile:infoPath];
        
    }
    return self;
}

- (void)importGuideInfo
{
    for (int i = (int)_guideInfos.count - 1; i >= 0; i--) {
    
        NSDictionary *info = _guideInfos[i];
        
        ReadFile *readFile = [ReadFile createEntity];
        readFile.createTime = [NSDate new];
        readFile.userID = [LBUserManager defaultManager].currentUser.userID;
        readFile.fileID = [[LBIndexInfoManager defaultManager] getFileID];
        readFile.title = info[@"title"];
        readFile.content = info[@"content"];
        
        NSString *fromPDFPath = [[NSBundle mainBundle] pathForResource:info[@"fileName"] ofType:@"pdf"];
        NSString *toPDFPath = [[LBReadFileFileManager defaultManager] pathForReadFile:readFile.fileID];
        [[NSFileManager defaultManager] copyItemAtPath:fromPDFPath toPath:toPDFPath error:nil];
    
        Appendix *appendix = [Appendix createEntity];
        appendix.userID = [LBUserManager defaultManager].currentUser.userID;
        appendix.appendixID = [[LBIndexInfoManager defaultManager] getAppendixID];
        
        NSString *fromTBPath = [[NSBundle mainBundle] pathForResource:info[@"thumbnailName"] ofType:nil];
        NSString *toTBPath = [[LBAppendixFileManager defaultManager] pathForAppendix:appendix.appendixID];
        
        [[NSFileManager defaultManager] copyItemAtPath:fromTBPath toPath:toTBPath error:nil];
        
        readFile.thumbnailID = appendix.appendixID;
      
    }
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}
@end
