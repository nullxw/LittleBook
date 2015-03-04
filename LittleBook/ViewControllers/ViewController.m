//
//  ViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/1.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "ViewController.h"
#import "ReadViewController.h"
#import "OfficeViewController.h"
#import "FinanceViewController.h"
#import "ExtensionKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)openNextPage:(UIButton *)sender
{
    HPTabBarChildController *vc = nil;
    
    NSInteger tag = sender.tag;
    
    switch (tag) {
        case 0:
            vc = [ReadViewController loadFromStoryboard];
            break;
        case 1:
            vc = [OfficeViewController loadFromStoryboard];
            break;
        case 2:
            vc = [FinanceViewController loadFromStoryboard];
            break;
        default:
            break;
    }
    
    [self openViewController:vc fromTabBar:self.tabBarItems[tag] animated:YES completion:^{
        
    }];
}

@end
