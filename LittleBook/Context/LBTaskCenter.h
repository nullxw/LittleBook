//
//  ILSTaskCenter.h
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LBTaskCenter : NSObject

+ (LBTaskCenter *)defaultCenter;

- (void)registerAppTasks;

- (BOOL)taskHasComplete:(NSString *)taskKey;

- (BOOL)completeTask:(NSString *)taskKey;

- (BOOL)completeWrongPasswrodTask;

@end
