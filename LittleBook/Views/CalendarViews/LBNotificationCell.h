//
//  LBNotificationCell.h
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Notification;

@interface LBNotificationCell : UITableViewCell

- (void)setupWithNotification:(Notification *)notification;

@end
