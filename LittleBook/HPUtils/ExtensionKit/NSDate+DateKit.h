//
//  ILS.h
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (DateKit)

// chat list 界面的 日期格式
- (NSString *)formattedStringCompareWithNow;

// chat 界面的日期格式
- (NSString *)formattedStringForMessage;

- (BOOL)inSameWeek:(NSDate *)date;

- (NSInteger)getWeekIndex;

@end
