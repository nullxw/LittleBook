//
//  ILSDailyTaskManager.h
//  snapgrab
//
//  Created by hupeng on 14-6-27.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HPTaskManagerCompletionBlock)(NSError *error);

typedef enum {
    HPTaskTypeNormalTask,
    HPTaskTypeDailyTask,
    HPTaskTypeWeeklyTask,
} HPTaskType;

typedef enum {
    HPTaskWeekdayMonday = 1 << 2,
    HPTaskWeekdayTuesday = 1 << 3,
    HPTaskWeekdayWednesday = 1 << 4,
    HPTaskWeekdayThursday = 1 << 5,
    HPTaskWeekdayFriday = 1 << 6,
    HPTaskWeekdaySaturday = 1 << 7,
    HPTaskWeekdaySunday = 1 << 1,
} HPTaskWeekday;

typedef NSUInteger HPTaskWeekdays;

static NSString *kHPTaskManagerTaskKey = @"kHPTaskManagerTaskKey";
static NSString *kHPTaskManagerTaskUser = @"kHPTaskManagerTaskUser";

static NSString *kHPTaskManagerErrorDuplicatedTask  = @"kHPTaskManagerErrorDuplicatedTask";
static NSString *kHPTaskManagerErrorTaskNotFound    = @"kHPTaskManagerErrorTaskNotFound";
static NSString *kHPTaskManagerErrorTaskHasFinished = @"kHPTaskManagerErrorTaskHasFinished";
static NSString *kHPTaskManagerErrorInvalidParams   = @"kHPTaskManagerErrorInvalidParams";

typedef enum {
    kHPTaskManagerErrorDuplicatedTaskCode = 101,
    kHPTaskManagerErrorTaskNotFoundCode,
    kHPTaskManagerErrorTaskHasFinishedCode,
    kHPTaskManagerErrorInvalidParamsCode
} kHPTaskManagerErrorCode;

@interface HPTaskManager : NSObject

+ (HPTaskManager *)defaultManager;

@property (nonatomic, strong) NSUserDefaults *userDefaults;

- (id)objectForKey:(NSString *)key;

- (void)setObject:(id)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

/****************************************** 普通任务 － key不失效 ******************************************/

// return FALSE :
//      1.已经注册过当天的任务
// return TRUE :
//      1.注册成功

- (BOOL)registerNoramlTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes;

// return FALSE :
//      1.未注册过该任务
//      2.任务已被完成
// return TRUE :
//      1.成功完成任务 ,任务数 -1
// HPTaskType 只支持 HPTaskTypeNormalTask or HPTaskTypeDailyTask

- (BOOL)completeTask:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType;

// return FALSE :
//      1.未注册过该任务
// return TRUE :
//      1.任务次数剩余量为0
// HPTaskType 只支持 HPTaskTypeNormalTask or HPTaskTypeDailyTask

- (BOOL)taskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType;


/****************************************** 每日任务 － key一天内失效 ******************************************/

// return FALSE :
//      1.已经注册过当天的任务
// return TRUE :
//      1.注册成功
- (BOOL)registerDailyTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes;

// return FALSE :
//      1.未注册过该任务
//      2.任务已被完成
// return TRUE :
//      1.成功完成任务 ,任务数 -1

// @deprecated
// use - (BOOL)completeTask:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType
- (BOOL)completeTask:(NSString *)taskKey forUser:(NSString *)userName;

// return FALSE :
//      1.未注册过该任务
// return TRUE :
//      1.任务次数剩余量为0

// @deprecated
// use - (BOOL)taskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType
- (BOOL)taskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName;


/****************************************** 每周任务 - key一天内失效 ******************************************/

// return FALSE :
//      1.已经注册过当天的任务
//      2.当前日期 不是设定的 weekday
// return TRUE :
//      1.注册成功
- (BOOL)registerWeeklyTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes onSpecifiedWeekdays:(HPTaskWeekdays)weekdays;

// return FALSE :
//      1.当前日期 不是设定的 weekday
//      2.未注册过该任务
//      3.任务已被完成
// return TRUE :
//      1.成功完成任务 ,任务数 -1

- (BOOL)completeTask:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays;


// return FALSE :
//      1.当前日期 不是设定的 weekday
//      2.未注册过该任务
// return TRUE :
//      1.任务次数剩余量为0

- (BOOL)weeklyTaskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays;

/****************************************** 阶段任务 - key 自动失效 ******************************************/

// return FALSE :
//      1.已经注册过该的任务
// return TRUE :
//      1.注册成功
- (BOOL)registerPeriodicTask:(NSString *)taskKey forUser:(NSString *)userName fromDate:(NSDate *)fDate toDate:(NSDate *)tDate;

- (BOOL)registerPeriodicTask:(NSString *)taskKey forUser:(NSString *)userName fromDate:(NSDate *)fDate duration:(NSUInteger)days;

// return FALSE :
//      1.没有该任务
// return TRUE :
//      1.成功取消该任务
- (BOOL)revokePeriodicTask:(NSString *)taskKey forUser:(NSString *)userName;

// return FALSE :
//      1.任务未注册
//      2.任务已失效
// return TRUE :
//      1.任务在有效期内
- (BOOL)periodicTaskIsValid:(NSString *)taskKey forUser:(NSString *)userName;

/****************************************** key generators ******************************************/

- (NSString *)getPreviousWeeklyKey:(NSString *)taskKey forUser:(NSString *)userName;

- (NSString *)getPreviousDailyKey:(NSString *)taskKey forUser:(NSString *)userName;

- (NSString *)getUserKey:(NSString *)taskKey forUser:(NSString *)userName;

- (NSString *)getDailyKey:(NSString *)taskKey forUser:(NSString *)userName;

- (NSString *)getWeeklyKey:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays;

- (NSDate *)filterDateFromeILSTaskKey:(NSString *)ILSTaskKey;

/****************************************** thread safe methods ******************************************/

- (void)registerNoramlTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock;

- (void)registerDailyTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock;

- (void)completeTask:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock;

- (BOOL)threadSafeTaskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName taskType:(HPTaskType)taskType;

- (void)registerWeeklyTask:(NSString *)taskKey forUser:(NSString *)userName taskTimes:(NSInteger)maxTimes onSpecifiedWeekdays:(HPTaskWeekdays)weekdays withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock;

- (void)completeTask:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock;

- (BOOL)threadSafeWeeklyTaskHasCompleted:(NSString *)taskKey forUser:(NSString *)userName onSpecifiedWeekdays:(HPTaskWeekdays)weekdays;

- (void)registerPeriodicTask:(NSString *)taskKey forUser:(NSString *)userName fromDate:(NSDate *)fDate toDate:(NSDate *)tDate withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock;

- (void)registerPeriodicTask:(NSString *)taskKey forUser:(NSString *)userName fromDate:(NSDate *)fDate duration:(NSUInteger)days withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock;

- (void)revokePeriodicTask:(NSString *)taskKey forUser:(NSString *)userName withCompletionBlock:(HPTaskManagerCompletionBlock)completionBlock;

- (BOOL)threadSafePeriodicTaskIsValid:(NSString *)taskKey forUser:(NSString *)userName;

@end
