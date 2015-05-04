//
//  LBIndexInfoManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBIndexInfoManager.h"
#import "IndexInfo.h"

@interface LBIndexInfoManager ()
{
    IndexInfo *_indexInfo;
    unsigned long _maxAppendixID;
    unsigned long _maxDocumentID;
    unsigned long _maxAccountDetailID;
    unsigned long _maxNotificationID;
}
@end

@implementation LBIndexInfoManager

+ (LBIndexInfoManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBIndexInfoManager alloc] init]);
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _indexInfo = [IndexInfo findFirst];
        if (!_indexInfo) {
            _indexInfo = [IndexInfo createEntity];
            _indexInfo.maxAppendixID     = @(0);
            _indexInfo.maxDocumentID     = @(0);
            _indexInfo.maxAccountDetailID= @(0);
            _indexInfo.maxNotificationID = @(0);
        }
        _maxAppendixID = _indexInfo.maxAppendixID.unsignedLongValue;
        _maxDocumentID = _indexInfo.maxDocumentID.unsignedLongValue;
        _maxAccountDetailID = _indexInfo.maxAccountDetailID.unsignedLongValue;
        _maxNotificationID  = _indexInfo.maxNotificationID.unsignedIntegerValue;
    }
    return self;
}

- (NSNumber *)getAppendixID
{
    _indexInfo.maxAppendixID = @(++_maxAppendixID);
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return _indexInfo.maxAppendixID;
}

- (NSNumber *)getDocumentID
{
    _indexInfo.maxDocumentID = @(++_maxDocumentID);
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    
    return _indexInfo.maxDocumentID;
}

- (NSNumber *)getAccountDetailID
{
    _indexInfo.maxAccountDetailID = @(++_maxAccountDetailID);
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return _indexInfo.maxAccountDetailID;
}
- (NSNumber *)getNotificationID
{
    _indexInfo.maxNotificationID = @(++_maxNotificationID);
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return _indexInfo.maxNotificationID;
}
@end
