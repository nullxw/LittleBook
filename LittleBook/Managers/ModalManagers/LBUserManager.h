//
//  LBUserManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBUser.h"

@interface LBUserManager : NSObject

+ (LBUserManager *)defaultManager;

@property (nonatomic ,strong) LBUser *currentUser;

@end
