//
//  ILSTaskCenter.m
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//
#define ILSPP_WRONG_PASSWORD_MAX_TYR_TIME 9

#import "LBTaskCenter.h"
#import "HPTaskManager.h"
#import "HPCommonMacro.h"

@interface LBTaskCenter ()
{
//    HPTaskManager *_taskManger;
    NSMutableDictionary *_taskTypeInfos;
    NSMutableDictionary *_taskUserInfos;
    NSMutableDictionary *_taskManagerInfos;
    
    HPTaskManager *_keyChainTaskManger;
    HPTaskManager *_userDefaultTaskManger;
}
@end

@implementation LBTaskCenter

+ (LBTaskCenter *)defaultCenter
{
    CREATE_SINGLETON_INSTANCE([[LBTaskCenter alloc] init]);
}

- (id)init
{
    if (self = [super init]) {
        
        _keyChainTaskManger = [[HPTaskManager alloc] init];
        _keyChainTaskManger.storePolicy = HPTaskStorePolicyKeyChain;
        
        _userDefaultTaskManger = [[HPTaskManager alloc] init];
        _userDefaultTaskManger.storePolicy = HPTaskStorePolicyUserDefault;
        
        _taskManagerInfos = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        _taskTypeInfos = [[NSMutableDictionary alloc] initWithCapacity:0];
        _taskUserInfos = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)registerAppTasks
{
    // 1. 相册列表-相册缩略图页面（俩页面功用该任务） 下拉提示引导
    // 用户进行下拉操作后完成改任务，不再出现该引导

    [_keyChainTaskManger registerNoramlTask:LB_GUIDE_TASK_KEY forUser:LB_DEFAULT_USER taskTimes:1];
    _taskManagerInfos[LB_GUIDE_TASK_KEY] = _keyChainTaskManger;

}


- (BOOL)taskHasComplete:(NSString *)taskKey
{
    return [[self taskManagerForKey:taskKey] taskHasCompleted:taskKey forUser:[self taskUserForKey:taskKey] taskType:[self taskTypeForKey:taskKey]];
}

- (BOOL)completeTask:(NSString *)taskKey
{

    return [[self taskManagerForKey:taskKey] completeTask:taskKey forUser:[self taskUserForKey:taskKey] taskType:[self taskTypeForKey:taskKey]];
}

- (HPTaskType)taskTypeForKey:(NSString *)taskKey
{
    if (![_taskTypeInfos objectForKey:taskKey]) {
        return HPTaskTypeNormalTask;
    }
    
    HPTaskType taskType = (HPTaskType)[[_taskTypeInfos objectForKey:taskKey] integerValue];
    
    return taskType;
}

- (NSString *)taskUserForKey:(NSString *)taskKey
{
    if (![_taskUserInfos objectForKey:taskKey]) {
        return LB_DEFAULT_USER;
    }
    return [_taskUserInfos objectForKey:taskKey];
}

- (HPTaskManager *)taskManagerForKey:(NSString *)taskKey
{
    return _taskManagerInfos[taskKey];
}
@end