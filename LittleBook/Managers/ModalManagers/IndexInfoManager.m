//
//  IndexInfoManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "IndexInfoManager.h"
#import "IndexInfo.h"

@interface IndexInfoManager ()
{
    IndexInfo *_indexInfo;
    unsigned long _maxAppendixID;
    unsigned long _maxDocumentID;
    unsigned long _maxAccountID;
}
@end

@implementation IndexInfoManager

+ (IndexInfoManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[IndexInfoManager alloc] init]);
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _indexInfo = [IndexInfo findFirst];
        if (!_indexInfo) {
            _indexInfo = [IndexInfo createEntity];
            _indexInfo.maxAppendixID = @(0);
            _indexInfo.maxDocumentID = @(0);
            _indexInfo.maxAcoountID  = @(0);
        }
        _maxAppendixID = _indexInfo.maxAppendixID.unsignedLongValue;
        _maxDocumentID = _indexInfo.maxDocumentID.unsignedLongValue;
        _maxAccountID  = _indexInfo.maxAcoountID.unsignedLongValue;
    }
    return self;
}

- (NSNumber *)getAppendixID
{
    return (_indexInfo.maxAppendixID = @(++_maxAppendixID));
}

- (NSNumber *)getDocumentID
{
    return (_indexInfo.maxDocumentID = @(++_maxDocumentID));
}

- (NSNumber *)getAccountID
{
    return (_indexInfo.maxAcoountID = @(++_maxAccountID));
}
@end
