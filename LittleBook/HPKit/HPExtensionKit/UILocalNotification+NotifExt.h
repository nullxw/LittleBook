//
//  UILocalNotification+NotifExt.h
//  LittleBook
//
//  Created by 胡鹏 on 15/5/24.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILocalNotification (NotifExt)

+ (UILocalNotification *)findByID:(id)notifID;

- (void)setID:(id)notifID;

@end
