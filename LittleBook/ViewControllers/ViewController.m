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
    
    self.view.backgroundColor = currentHour >= 18 ? [UIColor colorWithR:0 g:0 b:70 a:1.0] : [UIColor colorWithR:0 g:32 b:206 a:1.0];
}

#pragma mark - tabbar events

- (IBAction)didClickTabBar:(UIButton *)sender
{
    self.seletectedTabbar = (HPTabBar *)sender.superview;
}

@end
