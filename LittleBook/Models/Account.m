//
//  Account.m
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//


#import "Account.h"

static int kLBAccountMaxAppendixs = 5;
static NSString *kLBAccountAppendixSeperator = @"-";
@implementation Account

@dynamic accountID;
@dynamic createTime;
@dynamic totalCost;
@dynamic userID;
@dynamic appendixs;

+ (NSString *)generateAccountIDFromDate:(NSDate *)date
{
    return [date formattedString:@"yyyy-MM-dd"];
}

- (void)updateAccountAppendixs:(NSArray *)appendixIDs
{
    NSMutableArray *sAppendixIDs = @[].mutableCopy;

    if ([self.appendixs isEmpty]) {

        for (int i = (int)MIN(appendixIDs.count, kLBAccountMaxAppendixs) - 1; i >= 0 ; i--) {
            
            [sAppendixIDs addObject:appendixIDs[i]];
        }
    } else {
        sAppendixIDs = [self.appendixs componentsSeparatedByString:kLBAccountAppendixSeperator].mutableCopy;
        for (int i = (int)appendixIDs.count - 1; i >= 0; i--) {
            [sAppendixIDs insertObject:appendixIDs[i] atIndex:0];
        }
        sAppendixIDs = [sAppendixIDs subarrayWithRange:NSMakeRange(0, MIN(kLBAccountMaxAppendixs, sAppendixIDs.count))].mutableCopy;
       
    }
    
    self.appendixs = [sAppendixIDs componentsJoinedByString:kLBAccountAppendixSeperator];
}

- (NSArray *)appendixIDs
{
    if ([self.appendixs isEmpty]) {
        return nil;
    }
    NSMutableArray *sAppendixIDs = @[].mutableCopy;
    
    for (NSString *sAppendixID in [self.appendixs componentsSeparatedByString:kLBAccountAppendixSeperator]) {
        [sAppendixIDs addObject:@(sAppendixID.integerValue)];
    }
    return sAppendixIDs;
}
@end
