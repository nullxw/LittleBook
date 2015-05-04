//
//  LBNotificationDotView.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/11.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPAutoResizeCell.h"

@interface LBNotificationSettingCell : HPAutoResizeCell

@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UISwitch *switchView;

@end
