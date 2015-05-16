//
//  ReadFile.h
//  
//
//  Created by 胡鹏 on 15/5/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReadFile : NSManagedObject

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * fileID;
@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSDate * modifiedTime;
@property (nonatomic, retain) NSString * userID;

@end
