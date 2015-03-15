//
//  HPTabBarChildController.h
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPTabBar;

@interface HPTabBarChildController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) IBOutlet HPTabBar *navigationBar;

- (IBAction)dismiss;

@end
