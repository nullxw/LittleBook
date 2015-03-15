//
//  HPTabBar.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPTabBar.h"

@implementation HPTabBar

- (void)startHideAnimationWithDuration:(float)duration completion:(void (^)(void))completion
{
    float ox = self.center.x;
    float oy = self.center.y;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.center = CGPointMake(ox, oy - kHPTabBarMarginTop);
        //...other animations
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)startShowAnimationWithDuration:(float)duration completion:(void (^)(void))completion
{
    float ox = self.center.x;
    float oy = self.center.y;
    
    self.center = CGPointMake(ox, oy - kHPTabBarMarginTop);
    
    [UIView animateWithDuration:duration animations:^{
        
        self.center = CGPointMake(ox, oy);
        //...other animations
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end