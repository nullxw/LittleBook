//
//  HPTabBarItem.h
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPTabBarItem;

@protocol HPTabBarItemProtocol <NSObject>

- (void)didClickTabBar:(HPTabBarItem *)tabbar;

@end

@interface HPTabBarItem : UIView

@property (nonatomic, assign) IBOutlet id <HPTabBarItemProtocol> delegate;

- (void)startHideAnimationWithDuration:(float)duration completion:(void (^)(void))completion;

- (void)startShowAnimationWithDuration:(float)duration completion:(void (^)(void))completion;

@end
