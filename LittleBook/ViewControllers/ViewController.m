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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;
@property (weak, nonatomic) IBOutlet UIImageView *Logo;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sectionView.separateLineColor = [UIColor colorWithRed:32.0/255.0 green:38.0/255.0 blue:56.0/255.0 alpha:1.0];
    _sectionView.sectionNumber = 3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger currentHour = [[NSDate new] getDateComponent:NSCalendarUnitHour];
    
    _Logo.image = currentHour >= 6 ? [UIImage imageNamed:@"topLogo_night"] : [UIImage imageNamed:@"topLogo_moring"];

}

#pragma mark - tabbar events

- (IBAction)didClickTabBar:(UIButton *)sender
{
    self.seletectedTabbar = (HPTabBar *)sender.superview;
}

@end
