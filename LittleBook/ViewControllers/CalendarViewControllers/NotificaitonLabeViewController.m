//
//  NotificaitonLabeViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/29.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificaitonLabeViewController.h"

@interface NotificaitonLabeViewController ()

@end

@implementation NotificaitonLabeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
