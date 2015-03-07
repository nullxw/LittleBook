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

- (void)awakeFromNib
{
    [self registerGestures];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self registerGestures];
    }
    return self;
}

- (void)registerGestures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTabBar:)];
    [self addGestureRecognizer:tap];
}

- (void)tapTabBar:(UIGestureRecognizer *)gesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(didClickTabBar:)]) {
        [_delegate didClickTabBar:self];
    }
}

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
    
    self.center = CGPointMake(ox, oy - kHPTabBarItemMarginTop);
    
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