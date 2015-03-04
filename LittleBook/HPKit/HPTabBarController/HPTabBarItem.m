//
//  HPTabBarItem.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

static const float kHPTabBarItemMarginTop = 20.0;

#import "HPTabBarItem.h"

@implementation HPTabBarItem

- (void)startHideAnimationWithDuration:(float)duration completion:(void (^)(void))completion
{
    float ox = self.center.x;
    float oy = self.center.y;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.center = CGPointMake(ox, oy - kHPTabBarItemMarginTop);
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
    
    [UIView animateWithDuration:duration animations:^{
        
        self.center = CGPointMake(ox, oy + kHPTabBarItemMarginTop);
        //...other animations
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}


- (id)copyWithZone:(NSZone *)zone
{
    HPTabBarItem *copyItem = [[[self class] allocWithZone:zone] init];
    copyItem.backgroundColor = self.backgroundColor;
    copyItem.frame = self.frame;
    copyItem.tag = self.tag;
    //... copy other attributes
    return copyItem;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    HPTabBarItem *copyItem = [[[self class] allocWithZone:zone] init];
    copyItem.backgroundColor = self.backgroundColor;
    copyItem.frame = self.frame;
    copyItem.tag = self.tag;
    //... copy other attributes
    return copyItem;
}


@end
