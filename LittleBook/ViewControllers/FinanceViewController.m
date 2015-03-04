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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    HPTarBarController *rootViewController = (HPTarBarController *)self.parentViewController;
    
    [rootViewController closeViewController:self
                                   toTabBar:rootViewController.tabBarItems[self.navigationBar.tag] animated:YES
                                 completion:nil];
}

@end
