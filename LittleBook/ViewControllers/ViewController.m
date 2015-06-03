//
//  ViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/1.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//
#import "ViewController.h"
#import "LBSectionView.h"
#import "HPTabBar.h"

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger currentHour = [[NSDate new] getDateComponent:NSCalendarUnitHour];
    
   // _Logo.image = currentHour >= 6 ? [UIImage imageNamed:@"topLogo_night"] : [UIImage imageNamed:@"topLogo_moring"];
}

#pragma mark - tabbar events

- (IBAction)didClickTabBar:(UIButton *)sender
{
    self.seletectedTabbar = (HPTabBar *)sender.superview;
}

@end
