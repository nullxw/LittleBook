//
//  HPDownFrequenceMachine.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/27.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPDownFrequenceMachine.h"
#include <pthread/pthread.h>

@interface HPDownFrequenceMachine ()
{
    __block void(^_eventHandleBlock)();
    int _operationCount;
    pthread_mutex_t _mutex;
    dispatch_queue_t _eventHandleQueue;
}
@end

@implementation HPDownFrequenceMachine

- (instancetype)init
{
    if (self = [super init]) {
        _operationCount = 0;
        pthread_mutex_init(&_mutex, NULL);
        _eventHandleQueue = dispatch_queue_create("HPDownFrequenceMachine", 0);
    }
    return self;
}

- (void)handleEvent
{
    pthread_mutex_lock(&_mutex);
    ++_operationCount;
    pthread_mutex_unlock(&_mutex);
    NSLog(@"%d", _operationCount);
    dispatch_async(_eventHandleQueue, ^{
        [self handleEventInBackground];
    });
}

- (void)handleEventInBackground
{
    int emptyLoopCount = 0;
    do {
        pthread_mutex_lock(&_mutex);
        if (_operationCount > 1) {
            --_operationCount;
            pthread_mutex_unlock(&_mutex);
            
            NSLog(@"cancel operation");
            return;
        }
        pthread_mutex_unlock(&_mutex);
        [NSThread sleepForTimeInterval:0.1];
    } while (++emptyLoopCount < 20);
    
    if (_eventHandleBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _eventHandleBlock();
        });
    }
    
    pthread_mutex_lock(&_mutex);
    --_operationCount;
    pthread_mutex_unlock(&_mutex);
}

- (void)registerEventHandleBlock:(void(^)())block
{
    _eventHandleBlock = block;
}

@end
