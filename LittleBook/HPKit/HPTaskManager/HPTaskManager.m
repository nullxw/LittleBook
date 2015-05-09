//
//  ILSDailyTaskManager.m
//  snapgrab
//
//  Created by hupeng on 14-6-27.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "HPTaskManager.h"
#import "NSDate+DateExt.h"
#import "SSKeychain.h"

#define ILS_TASK_MANAGER_DAILY_KEY(uesrname, task_key)      ([NSString stringWithFormat:@"ILS_TASK_MANAGER_DAILY_KEY_%@_%@", (uesrname).uppercaseString, (task_key).uppercaseString])

#define ILS_TASK_MANAGER_WEEKLY_KEY(uesrname, task_key)     ([NSString stringWithFormat:@"ILS_TASK_MANAGER_WEEKLY_KEY_%@_%@", (uesrname).uppercaseString, (task_key).uppercaseString])

static NSString *kHPTaskManagerUserDefaultSuiteName = @"kHPTaskManagerUserDefaultSuiteName";

static NSString *kHPTaskManagerPeriodicTaskFDataKey = @"kHPTaskManagerPeriodicTaskFDataKey";
static NSString *kHPTaskManagerPeriodicTaskTDataKey = @"kHPTaskManagerPeriodicTaskTDataKey";
static NSString *kHPTaskManagerDefaultUser = @"kHPTaskManagerDefaultUser";


@interface NSString (toDictionary)

- (NSDictionary *)toDictionary;
@end

@interface NSDictionary (toString)

- (NSString *)toString;

@end

@implementation NSString (toDictionary)

- (NSDictionary *)toDictionary
{
    NSArray *pairs = [self componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:pairs.count];
    
    for (NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@":"];
        [dic setObject:keyValue[1] forKey:keyValue[0]];
    }
    return dic;
}

@end

@implementation NSDictionary (toString)

- (NSString *)toString
{
    NSArray *keys = self.allKeys;
    
    NSString *str = @"";
    
    for (NSString *key in keys) {
        str = [NSString stringWithFormat:@"%@%@:%@,", str, key , self[key]];
    }
    // clip last ,
    str = [str substringToIndex:str.length - 1];
    
    return str;
}

@end

@interface HPTaskManager ()
{
    NSDateFormatter *_formatter;
    dispatch_queue_t _taskQueue;
    NSUserDefaults  *_userDefaults;
}
@end

@implementation HPTaskManager

+ (HPTaskManager *)defaultManager
{
    static HPTaskManager *_defaultManager = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        _defaultManager = [[HPTaskManager alloc] init];
        
    });
    return _defaultManager;
}

- (id)init
{
    self = [super init];
    if (self) {
    
        // NSGregorianCalendar , weekday 1-7 ; 1 means Sunday
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
        [_formatter setCalendar:cal];
    
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kHPTaskManagerUserDefaultSuiteName];
        
        _taskQueue = dispatch_queue_create("HPTaskManager+ThreadSafe", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

/********************************* 数据存储方式 - 可根据需求实现不同的存储策略 *********************************/

- (NSString *)objectForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    
    if (_storePolicy == HPTaskStorePolicyKeyChain) {
        return [SSKeychain passwordForService:key account:kHPTaskManagerDefaultUser];
    } else {
        return [_userDefaults objectForKey:key];
    }
}

- (void)setObject:(NSString *)object forKey:(NSString *)key
{
    if (!key || !object) {
        return;
    }
    
    if (_storePolicy == HPTaskStorePolicyKeyChain) {
        [SSKeychain setPassword:object forService:key account:kHPTaskManagerDefaultUser];
    } else {
        [_userDefaults setObject:object forKey:key];
        
        [_userDefaults synchronize];
    }
}

- (void)removeObjectForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    if (_storePolicy == HPTaskStorePolicyKeyChain) {
        [SSKeychain deletePasswordForService:key account:kHPTaskManagerDefaultUser];
    } else {
        [_userDefaults removeObjectForKey:key];
        [_userDefaults synchronize];
    }
    
}

/****************************************** 普通任务 － key不失效 ******************************************/

- (BOOL)registerNoramlTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes
{
    if (maxTimes < 0 || !taskKey) {
        return FALSE;
    }
    
    NSString *userKey = [self getUserKey:taskKey forUser:userName];
    
    if ([self objectForKey:userKey]) {
        return FALSE;
    }
    [self setObject:@(maxTimes).stringValue forKey:userKey];
    
    return TRUE;
}

- (BOOL)completeTask:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType
{
    NSString *key = taskType == HPTaskTypeDailyTask ? [self getDailyKey:taskKey forUser:userName] : [self getUserKey:taskKey forUser:userName];
    
    NSString *taskTimes = [self objectForKey:key];
    
    if (!taskTimes) {
        return FALSE;
    }
    
    __block NSInteger iTaskTimes = [taskTimes integerValue];
    
    --iTaskTimes;
    
    [self setObject:@(iTaskTimes).stringValue forKey:key];
    
    return iTaskTimes >= 0;
}

- (BOOL)taskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType
{
    if (!taskKey) {
        return FALSE;
    }
    
    NSString *key = taskType == HPTaskTypeDailyTask ? [self getDailyKey:taskKey forUser:userName] : [self getUserKey:taskKey forUser:userName];
    
    NSString *taskTimes = [self objectForKey:key];
    
    if (!taskTimes) {
        return FALSE;
    }
    
    return [taskTimes integerValue] <= 0;
}

/****************************************** 每日任务 － key一天内失效 ******************************************/

- (BOOL)registerDailyTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes
{
    if (maxTimes < 0 || !taskKey) {
        return FALSE;
    }
    
    NSString *dailyKey = [self getDailyKey:taskKey forUser:userName];
    
    if ([self objectForKey:dailyKey]) {
        return FALSE;
    }
    
    NSString *previousKey = [self getPreviousDailyKey:taskKey forUser:userName];
    
    // remove previous infos
    if (previousKey) {
        [self removeObjectForKey:previousKey];
    }
    
    // set current info
    [self setObject:@(maxTimes).stringValue forKey:dailyKey];
    
    // save current key to delete key infos next time
    [self setObject:dailyKey forKey:ILS_TASK_MANAGER_DAILY_KEY(userName, taskKey)];
    
    return TRUE;
}

- (BOOL)completeTask:(NSString *)taskKey forUser:(NSString *)userName
{
    return [self completeTask:taskKey forUser:userName taskType:HPTaskTypeDailyTask];
}

- (BOOL)taskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName
{
    return [self taskHasCompleted:taskKey forUser:userName taskType:HPTaskTypeDailyTask];
}

/****************************************** 每周任务 ******************************************/

- (BOOL)registerWeeklyTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes onSpecifiedWeekdays:(HPTaskWeekdays)weekdays
{
    if (maxTimes < 0 || !taskKey) {
        return FALSE;
    }
    
    NSString *weeklyKey = [self getWeeklyKey:taskKey forUser:userName onSpecifiedWeekdays:weekdays];
    
    if (!weeklyKey) {
        return FALSE;
    }
    
    if ([self objectForKey:weeklyKey]) {
        return FALSE;
    }
    
    NSString *previousKey = [self getPreviousWeeklyKey:taskKey forUser:userName];
    
    // remove previous infos
    if (previousKey) {
        [self removeObjectForKey:previousKey];
    }
    
    // set current info
    [self setObject:@(maxTimes).stringValue forKey:weeklyKey];
    
    // save current key to delete key infos next time
    [self setObject:weeklyKey forKey:ILS_TASK_MANAGER_WEEKLY_KEY(userName, taskKey)];
    
    return TRUE;
}

- (BOOL)completeTask:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays
{
    if (!taskKey) {
        return FALSE;
    }
    NSString *weeklyKey = [self getWeeklyKey:taskKey forUser:userName onSpecifiedWeekdays:weekdays];
    
    if (!weeklyKey) {
        return FALSE;
    }
    
    NSString *taskTimes = [self objectForKey:weeklyKey];
    
    if (!taskTimes) {
        return FALSE;
    }
    
    NSInteger iTaskTimes = [taskTimes integerValue];
    
    --iTaskTimes;
    
    [self setObject:@(iTaskTimes).stringValue forKey:weeklyKey];
    
    return iTaskTimes >= 0;
}


- (BOOL)weeklyTaskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays
{
    if (!taskKey) {
        return FALSE;
    }
    
    NSString *weeklyKey = [self getWeeklyKey:taskKey forUser:userName onSpecifiedWeekdays:weekdays];
    
    if (!weeklyKey) {
        return FALSE;
    }
    
    NSString *taskTimes = [self objectForKey:weeklyKey];
    
    if (!taskTimes) {
        return FALSE;
    }
    
    return [taskTimes integerValue] <= 0;
}


/****************************************** 阶段任务 - key 自动失效 ******************************************/

- (BOOL)registerPeriodicTask:(NSString *)taskKey forUser:(NSString *)userName fromDate:(NSDate *)fDate toDate:(NSDate *)tDate
{
    if (!taskKey) {
        return FALSE;
    }
    
    NSString *periodicKey = [self getPeriodicUserKey:taskKey forUser:userName];
    
    if ([self objectForKey:periodicKey]) {
        return FALSE;
    }
    
    [self setObject:@{kHPTaskManagerPeriodicTaskFDataKey:fDate,
                      kHPTaskManagerPeriodicTaskTDataKey:tDate
                    }.toString forKey:periodicKey];
    return TRUE;
}

- (BOOL)registerPeriodicTask:(NSString *)taskKey forUser:(NSString *)userName fromDate:(NSDate *)fDate duration:(NSUInteger)days
{
    NSDate *tDate = [NSDate dateWithTimeInterval:days * 24 * 3600 sinceDate:fDate];
    return [self registerPeriodicTask:taskKey forUser:userName fromDate:fDate toDate:tDate];
}

- (BOOL)revokePeriodicTask:(NSString *)taskKey forUser:(NSString *)userName
{
    if (!taskKey) {
        return FALSE;
    }
    NSString *periodicKey = [self getPeriodicUserKey:taskKey forUser:userName];
    
    if (![self objectForKey:periodicKey]) {
        return FALSE;
    }
    [self removeObjectForKey:periodicKey];
    return TRUE;
}

- (BOOL)periodicTaskIsValid:(NSString *)taskKey forUser:(NSString *)userName
{
    if (!taskKey) {
        return FALSE;
    }
    NSString *periodicKey = [self getPeriodicUserKey:taskKey forUser:userName];
    
    NSDictionary *infos = [self objectForKey:periodicKey].toDictionary;
    if (!infos) {
        return FALSE;
    }
    NSDate *now = [NSDate date];
    
    if ([now timeIntervalSinceDate:infos[kHPTaskManagerPeriodicTaskFDataKey]] < 0) {
        return FALSE;
    }
    
    if ([now timeIntervalSinceDate:infos[kHPTaskManagerPeriodicTaskTDataKey]] > 0) {
        return FALSE;
    }
    return TRUE;
}

/****************************************** key generators ******************************************/

- (NSString *)getPreviousWeeklyKey:(NSString *)taskKey forUser:(NSString *)userName
{
    if (!userName) {
        userName = kHPTaskManagerDefaultUser;
    }
    return [self objectForKey:ILS_TASK_MANAGER_WEEKLY_KEY(userName, taskKey)];
}

- (NSString *)getPreviousDailyKey:(NSString *)taskKey forUser:(NSString *)userName
{
    if (!userName) {
        userName = kHPTaskManagerDefaultUser;
    }
    return [self objectForKey:ILS_TASK_MANAGER_DAILY_KEY(userName, taskKey)];
}

- (NSString *)getUserKey:(NSString *)taskKey forUser:(NSString *)userName
{
    if (!userName) {
        userName = kHPTaskManagerDefaultUser;
    }
    return [NSString stringWithFormat:@"%@_%@", taskKey, userName];
}

- (NSString *)getPeriodicUserKey:(NSString *)taskKey forUser:(NSString *)userName
{
    if (!userName) {
        userName = kHPTaskManagerDefaultUser;
    }
    return [NSString stringWithFormat:@"Periodic_%@_%@", taskKey, userName];
}

- (NSString *)getDailyKey:(NSString *)taskKey forUser:(NSString *)userName
{
    if (!userName) {
        userName = kHPTaskManagerDefaultUser;
    }
    NSDate *now = [NSDate new];
    NSString *timeStamp = [_formatter stringFromDate:now];
    
    // 加上 timeStamp 防止两次登陆都是 同一 weekday 引发bug
    
    return [NSString stringWithFormat:@"%@_%@#%@", taskKey, userName, timeStamp];
}

- (NSString *)getWeeklyKey:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays
{
    if (!userName) {
        userName = kHPTaskManagerDefaultUser;
    }
    
    NSDate *now = [NSDate new];
    
    NSDateComponents *components = [_formatter.calendar components: NSCalendarUnitWeekday fromDate:now];
    
    NSUInteger m = pow(2, components.weekday);
    
    // 不在设定的时间内
    if ((m & weekdays) == 0) {
        return nil;
    }
    
    NSString *previousKey = [self getPreviousWeeklyKey:taskKey forUser:userName];
    
    NSDate *previousRegisterDate = [self filterDateFromeILSTaskKey:previousKey];
    
    // 同一周内，不使用新key
    if (previousRegisterDate && [previousRegisterDate inSameWeek:now]) {
        return previousKey;
    }
    
    NSString *timeStamp = [_formatter stringFromDate:now];
    
    // 加上 timeStamp 防止两次登陆都是 同一 weekday 引发bug
    
    return [NSString stringWithFormat:@"%@_%@_%ld#%@", taskKey, userName, (long)weekdays , timeStamp];
}

- (NSDate *)filterDateFromeILSTaskKey:(NSString *)ILSTaskKey
{
    NSArray *comps = [ILSTaskKey componentsSeparatedByString:@"#"];
    NSString *dateStr = [comps lastObject];
    return [_formatter dateFromString:dateStr];
}

/****************************************** thread safe methods ******************************************/

- (void)registerNoramlTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock
{
    dispatch_barrier_async(_taskQueue, ^{
        
        if (maxTimes < 0 || !taskKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        NSString *userKey = [self getUserKey:taskKey forUser:userName];
        
        if ([self objectForKey:userKey]) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorDuplicatedTask
                                                    code:kHPTaskManagerErrorDuplicatedTaskCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        [self setObject:@(maxTimes).stringValue forKey:userKey];
        
        if (completionBlock) {
            completionBlock(nil);
        }
    });
}

- (void)registerDailyTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock
{
    dispatch_barrier_async(_taskQueue, ^{
        if (maxTimes < 0 || !taskKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:nil]);
            }
            return;
        }
        
        NSString *dailyKey = [self getDailyKey:taskKey forUser:userName];
        
        if ([self objectForKey:dailyKey]) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorDuplicatedTask
                                                    code:kHPTaskManagerErrorDuplicatedTaskCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }

        }
        
        NSString *previousKey = [self getPreviousDailyKey:taskKey forUser:userName];
        
        // remove previous infos
        if (previousKey) {
            [self removeObjectForKey:previousKey];
        }
        
        // set current info
        [self setObject:@(maxTimes).stringValue forKey:dailyKey];
        
        // save current key to delete key infos next time
        [self setObject:dailyKey forKey:ILS_TASK_MANAGER_DAILY_KEY(userName, taskKey)];
        
        if (completionBlock) {
            completionBlock(nil);
        }
    });
    
}

- (void)completeTask:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock
{
    dispatch_barrier_async(_taskQueue, ^{
        
        if (!taskKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:nil]);
            }
            return;
        }
        
        NSString *key = taskType == HPTaskTypeDailyTask ? [self getDailyKey:taskKey forUser:userName] : [self getUserKey:taskKey forUser:userName];
        
        NSString *taskTimes = [self objectForKey:key];
        
        if (!taskTimes) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorTaskNotFound
                                                    code:kHPTaskManagerErrorTaskNotFoundCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        __block NSInteger iTaskTimes = [taskTimes integerValue];
        
        --iTaskTimes;
        
        [self setObject:@(iTaskTimes).stringValue forKey:key];
        
        if (iTaskTimes >=0) {
            if (completionBlock) {
                completionBlock(nil);
            }
        } else {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorTaskHasFinished
                                                    code:kHPTaskManagerErrorTaskHasFinishedCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
        }
    });
}

- (BOOL)threadSafeTaskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType
{
    __block BOOL taskHasCompleted = FALSE;
    
    dispatch_sync(_taskQueue, ^{
        
        if (taskKey) {
            NSString *key = taskType == HPTaskTypeDailyTask ? [self getDailyKey:taskKey forUser:userName] : [self getUserKey:taskKey forUser:userName];
            
            NSString *taskTimes = [self objectForKey:key];
            
            if (taskTimes) {
                taskHasCompleted = [taskTimes integerValue] <= 0;
            }
        }
        
    });
    return taskHasCompleted;
}


- (void)registerWeeklyTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes onSpecifiedWeekdays:(HPTaskWeekdays)weekdays withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock
{
    dispatch_barrier_async(_taskQueue, ^{
        
        if (maxTimes < 0 || !taskKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        NSString *weeklyKey = [self getWeeklyKey:taskKey forUser:userName onSpecifiedWeekdays:weekdays];
        
        if (!weeklyKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        if ([self objectForKey:weeklyKey]) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorDuplicatedTask
                                                    code:kHPTaskManagerErrorDuplicatedTaskCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        NSString *previousKey = [self getPreviousWeeklyKey:taskKey forUser:userName];
        
        // remove previous infos
        if (previousKey) {
            [self removeObjectForKey:previousKey];
        }
        
        // set current info
        [self setObject:@(maxTimes).stringValue forKey:weeklyKey];
        
        // save current key to delete key infos next time
        [self setObject:weeklyKey forKey:ILS_TASK_MANAGER_WEEKLY_KEY(userName, taskKey)];
        
        if (completionBlock) {
            completionBlock(nil);
        }
    });
    
}

- (void)completeTask:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock
{
    dispatch_barrier_async(_taskQueue, ^{
        
        if (!taskKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:nil]);
            }
            return;
        }
        NSString *weeklyKey = [self getWeeklyKey:taskKey forUser:userName onSpecifiedWeekdays:weekdays];
        
        if (!weeklyKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        NSString *taskTimes = [self objectForKey:weeklyKey];
        
        if (!taskTimes) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorTaskNotFound
                                                    code:kHPTaskManagerErrorTaskNotFoundCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        NSInteger iTaskTimes = [taskTimes integerValue];
        
        --iTaskTimes;
        
        [self setObject:@(iTaskTimes).stringValue forKey:weeklyKey];
        
        if (iTaskTimes >=0) {
            if (completionBlock) {
                completionBlock(nil);
            }
        } else {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorTaskHasFinished
                                                    code:kHPTaskManagerErrorTaskHasFinishedCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
        }
    });
}

- (BOOL)threadSafeWeeklyTaskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays
{
    __block BOOL taskHasCompleted = FALSE;
    
    dispatch_sync(_taskQueue, ^{
        
        if (taskKey) {
            NSString *weeklyKey = [self getWeeklyKey:taskKey forUser:userName onSpecifiedWeekdays:weekdays];
            
            if (weeklyKey) {
                NSString *taskTimes = [self objectForKey:weeklyKey];
                
                if (taskTimes) {
                    taskHasCompleted = [taskTimes integerValue] <= 0;
                }
            }
        }
       
    });
    return taskHasCompleted;

}

- (void)registerPeriodicTask:(NSString *)taskKey forUser:(NSString *)userName fromDate:(NSDate *)fDate toDate:(NSDate *)tDate withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock
{
    dispatch_barrier_async(_taskQueue, ^{
        if (!taskKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        NSString *periodicKey = [self getPeriodicUserKey:taskKey forUser:userName];
        
        if ([self objectForKey:periodicKey]) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorDuplicatedTask
                                                    code:kHPTaskManagerErrorDuplicatedTaskCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }

        [self setObject:@{kHPTaskManagerPeriodicTaskFDataKey:fDate,
                          kHPTaskManagerPeriodicTaskTDataKey:tDate
                          }.toString forKey:periodicKey];
        if (completionBlock) {
            completionBlock(nil);
        }
    });
    
}

- (void)registerPeriodicTask:(NSString *)taskKey forUser:(NSString *)userName fromDate:(NSDate *)fDate duration:(NSUInteger)days withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock
{
    NSDate *tDate = [NSDate dateWithTimeInterval:days * 24 * 3600 sinceDate:fDate];
    
    [self registerPeriodicTask:taskKey forUser:userName fromDate:fDate toDate:tDate withCompletionBlock:^(NSError *error) {
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

- (void)revokePeriodicTask:(NSString *)taskKey forUser:(NSString *)userName withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock
{
    dispatch_barrier_async(_taskQueue, ^{
        if (!taskKey) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorInvalidParams
                                                    code:kHPTaskManagerErrorInvalidParamsCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        NSString *periodicKey = [self getPeriodicUserKey:taskKey forUser:userName];
        
        if (![self objectForKey:periodicKey]) {
            if (completionBlock) {
                completionBlock([NSError errorWithDomain:kHPTaskManagerErrorTaskNotFound
                                                    code:kHPTaskManagerErrorTaskNotFoundCode
                                                userInfo:@{kHPTaskManagerTaskKey:taskKey,
                                                           kHPTaskManagerTaskUser:userName}]);
            }
            return;
        }
        
        [self removeObjectForKey:periodicKey];
        if (completionBlock) {
            completionBlock(nil);
        }
    });
}

- (BOOL)threadSafePeriodicTaskIsValid:(NSString *)taskKey forUser:(NSString *)userName;
{
    __block BOOL isValid = FALSE;
    
    dispatch_sync(_taskQueue, ^{
        
        if (taskKey) {
            NSString *periodicKey = [self getPeriodicUserKey:taskKey forUser:userName];
            
            NSDictionary *infos = [self objectForKey:periodicKey].toDictionary;
            
            if (infos) {
                NSDate *now = [NSDate date];
                isValid = [now timeIntervalSinceDate:infos[kHPTaskManagerPeriodicTaskFDataKey]] >= 0 && [now timeIntervalSinceDate:infos[kHPTaskManagerPeriodicTaskTDataKey]] <= 0;
            }
        }
    });
    return isValid;
}
@end
