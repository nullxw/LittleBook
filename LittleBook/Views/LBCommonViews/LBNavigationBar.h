//
//  LBNavigationBar.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPTabBar.h"

#ifdef IB_DESIGNABLE
IB_DESIGNABLE
#endif


@interface LBNavigationBar : HPTabBar

@property (nonatomic, strong) IBOutlet UIImageView *navigtaionBarIcon;
@property (nonatomic, strong) IBOutlet UILabel *navigtaionBarTitle;
@property (nonatomic, strong) IBOutlet UILabel *navigtaionBarSubtitle;

#ifdef IBInspectable
@property (nonatomic, assign) IBInspectable float borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
#endif

@end
