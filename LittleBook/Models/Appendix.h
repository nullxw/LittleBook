//
//  Appendix.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Appendix : NSManagedObject

@property (nonatomic, retain) NSNumber * appendixID;
@property (nonatomic, retain) NSDate   * createTime;
@property (nonatomic, retain) NSString * frame;
@property (nonatomic, retain) NSNumber * parentID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * duration;
@end
