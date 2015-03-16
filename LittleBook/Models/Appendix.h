//
//  Appendix.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Appendix : NSManagedObject

@property (nonatomic, retain) NSNumber * appendixID;
@property (nonatomic, retain) NSNumber * documentID;
@property (nonatomic, retain) NSString * frame;
@property (nonatomic, retain) NSString * userID;

@end
