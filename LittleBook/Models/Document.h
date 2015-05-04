//
//  Document.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Document : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate   * createTime;
@property (nonatomic, retain) NSNumber * documentID;
@property (nonatomic, retain) NSString * documentSize;
@property (nonatomic, retain) NSDate   * modifiedTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userID;

@end
