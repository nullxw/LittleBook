//
//  HPTabBarItem.h
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPTabBarItem : UIView <NSCopying, NSMutableCopying>

- (void)startHideAnimationWithDuration:(float)duration completion:(void (^)(void))completion;

- (void)startShowAnimationWithDuration:(float)duration completion:(void (^)(void))completion;

@end
