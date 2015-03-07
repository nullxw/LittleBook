//
//  LBNavigationBar.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPTabBarItem.h"

@interface LBNavigationBar : HPTabBarItem

@property (nonatomic, strong) IBOutlet UIImageView *navigtaionBarIcon;
@property (nonatomic, strong) IBOutlet UILabel *navigtaionBarTitle;
@property (nonatomic, strong) IBOutlet UILabel *navigtaionBarSubtitle;

@end
