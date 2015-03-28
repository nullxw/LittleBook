//
//  HPTabBar.h
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

static const float kHPTabBarMarginTop = 20.0;

#import <UIKit/UIKit.h>
#import "HPRoundCornerView.h"

@interface HPTabBar : HPRoundCornerView

- (void)startHideAnimationWithDuration:(float)duration completion:(void (^)(void))completion;

- (void)startShowAnimationWithDuration:(float)duration completion:(void (^)(void))completion;

@end
