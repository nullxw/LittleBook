//
//  ViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/1.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//
#import "ViewController.h"
#import "LBSectionView.h"
#import "LBTaskCenter.h"
#import "HPTabBar.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[LBTaskCenter defaultCenter] taskHasComplete:LB_GUIDE_TASK_KEY]) {
        [[LBTaskCenter defaultCenter] completeTask:LB_GUIDE_TASK_KEY];
        [self performSegueWithIdentifier:@"openGuideView" sender:self];
    }
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
