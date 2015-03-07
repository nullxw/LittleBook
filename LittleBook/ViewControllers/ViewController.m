//
//  ViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/1.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//
#import "ViewController.h"
#import "FinanceViewController.h"
#import "SettingViewController.h"
#import "OfficeViewController.h"
#import "ReadViewController.h"
#import "LBNavigationBar.h"
#import "LBSectionView.h"
#import "ExtensionKit.h"

@interface ViewController () <HPTabBarItemProtocol>

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;

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

#pragma mark - section button event

- (IBAction)didClickSection:(UIButton *)sender
{
    UIViewController *vc = nil;
    NSInteger tag = sender.tag;
    
    switch (tag) {
        case 1:
            vc = [SettingViewController loadFromStoryboard];
            break;
            
        default:
            break;
    }

    [self presentViewController:vc
                  fromDirection:HPPresentViewControllerAnimationDirectionFromBottom
                       animated:YES
                     completion:nil];
}

#pragma mark - HPTabBarItemProtocol

- (void)didClickTabBar:(HPTabBarItem *)tabbar
{
    HPTabBarChildController *vc = nil;
    NSInteger tag = tabbar.tag;
    switch (tag) {
        case 0:
            vc = [OfficeViewController loadFromStoryboard];
            break;
        case 1:
            vc = [ReadViewController loadFromStoryboard];
            break;
        case 2:
            vc = [FinanceViewController loadFromStoryboard];
            break;
        default:
            break;
    }
    [self openViewController:vc
                  fromTabBar:tabbar
                    animated:YES
                  completion:nil];
}

@end
