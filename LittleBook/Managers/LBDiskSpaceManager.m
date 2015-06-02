//
//  LBDiskSpaceManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/6/2.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDiskSpaceManager.h"
#import "LBAppContext.h"

@implementation LBDiskSpaceManager

+ (void)checkDiskSpace
{
    LBAppContext *context = [LBAppContext context];
    
    NSNumber *alertStatus = context.settings[kLBNotificationSettingLowDiskSpace];
    
    if (![alertStatus boolValue]) {
        return;
    }
    
    long freeSpace = [LBDiskSpaceManager getFreeDiskspace]/1024/1024;

    if (freeSpace < 50) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您的内存已经低于50M！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

+ (uint64_t)getFreeDiskspace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], (int)[error code]);
    }
    
    return totalFreeSpace;
}

@end
