
//
//  UILocalNotification+NotifExt.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/24.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "UILocalNotification+NotifExt.h"

@implementation UILocalNotification (NotifExt)

+ (UILocalNotification *)findByID:(id)notifID
{
    NSArray *localNotificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *localNotification in localNotificaitons) {
        
        if ([localNotification.userInfo[@"notifID"] isEqual:notifID]) {
            return localNotification;
        }
    }
    return nil;
}

- (void)setID:(id)notifID
{
    self.userInfo = @{@"notifID" : notifID};
}
@end
