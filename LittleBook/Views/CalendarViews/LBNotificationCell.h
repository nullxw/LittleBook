//
//  LBNotificationCell.h
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPAutoResizeCell.h"

@class Notification;

@interface LBNotificationCell : HPAutoResizeCell

- (void)setupWithNotification:(Notification *)notification;

@end
