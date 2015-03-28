//
//  Notification.h
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * fireDate;
@property (nonatomic, retain) NSNumber * bellID;
@property (nonatomic, retain) NSNumber * remindLater;
@property (nonatomic, retain) NSNumber * on;
@property (nonatomic, retain) NSString * dayID;

@end
