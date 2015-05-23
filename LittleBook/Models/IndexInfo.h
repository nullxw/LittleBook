//
//  IndexInfo.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IndexInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * maxAppendixID;
@property (nonatomic, retain) NSNumber * maxAppendixParentID;
@property (nonatomic, retain) NSNumber * maxNotificationID;
@property (nonatomic, retain) NSString * userID;

@end
