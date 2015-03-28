//
//  ILS.m
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "NSDate+DateExt.h"

@implementation NSDate (DateExt)

- (NSString *)formattedStringCompareWithNow
{
    if (!self) {
        return nil;
    }
    
    NSDate *now = [NSDate new];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *deltaDateComps = [cal components:(NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self toDate:now options:NSCalendarWrapComponents];
    
    NSDateComponents *dateComps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSInteger deltaMin = deltaDateComps.minute;
    NSInteger deltaHour = deltaDateComps.hour;
    NSInteger deltaYear = deltaDateComps.year;
    
    if (deltaYear >= 1) {
        return [NSString stringWithFormat:@"%ld - %ld - %ld" , (long)dateComps.month, (long)dateComps.day, (long)dateComps.year];
    }
    if (deltaHour >= 48) {
        
        return [NSString stringWithFormat:@"%ld - %ld" , (long)dateComps.month, (long)dateComps.day];
    }
    if (deltaHour < 48 && deltaHour > 24) {
        return NSLocalizedString(@"yesterday", nil);
    }
    if (deltaHour <= 24 && deltaHour >= 1) {
        return deltaHour == 1 ? NSLocalizedString(@"1 hour ago", nil) : [NSString stringWithFormat:@"%ld %@", (long)deltaHour, NSLocalizedString(@"hours ago", nil)];
    }
    if (deltaMin < 60 && deltaMin > 1) {
        return [NSString stringWithFormat:@"%ld %@" , (long)deltaMin, NSLocalizedString(@"mins ago", nil)];
    }
    
    return NSLocalizedString(@"a moment ago", nil);
}


- (NSString *)formattedStringForMessage
{
    if (!self) {
        return nil;
    }
    
    NSDate *now = [NSDate new];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *deltaDateComps = [cal components:NSCalendarUnitDay fromDate:self toDate:now options:NSCalendarWrapComponents];
    
    NSDateComponents *dateComps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    
    NSInteger hour = dateComps.hour;
    
    NSString *suffix = @"AM";
    
    if (hour > 12) {
        suffix = @"PM";
        hour = hour - 12;
    }
    
    NSString *mintueStr = dateComps.minute > 9 ? [NSString stringWithFormat:@"%ld", (long)dateComps.minute] : [NSString stringWithFormat:@"0%ld",(long)dateComps.minute];

    
    if (deltaDateComps.day > 0) {
        return [NSString stringWithFormat:@"%ld/%ld/%ld %ld:%@ %@" , (long)dateComps.month, (long)dateComps.day, (long)dateComps.year, (long)hour, mintueStr, suffix];
    }

    return [NSString stringWithFormat:@"%ld:%@ %@",(long)hour,mintueStr, suffix];
}

- (BOOL)inSameWeek:(NSDate *)date
{
    if (!self) {
        return FALSE;
    }
    return [date getWeekIndex] == [self getWeekIndex];
}

- (NSInteger)getWeekIndex
{
    NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [cal components:NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday fromDate:self];
    
    // NSCalendarIdentifierGregorian 一般是currentCalendar
    // NSCalendarIdentifierGregorian 是从 周日 作为新的一周
    if (comps.weekday == 1) {
        return comps.weekOfYear - 1;
    } else {
        return comps.weekOfYear;
    }
}

- (NSString *)formattedString:(NSString *)pattern
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = pattern;
    return [formatter stringFromDate:self];
}
@end
