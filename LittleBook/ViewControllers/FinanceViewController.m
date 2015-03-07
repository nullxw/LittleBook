//
//  FinanceViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "FinanceViewController.h"
#import "HPTarBarController.h"
#import "HPTabBarItem.h"

@interface FinanceViewController ()

@end

@implementation FinanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)back:(id)sender
{
    HPTarBarController *rootViewController = (HPTarBarController *)self.parentViewController;
    
    [rootViewController closeViewController:self
                                   toTabBar:self.navigationBarOfTabBarController
                                   animated:YES
                                 completion:nil];
}

@end
