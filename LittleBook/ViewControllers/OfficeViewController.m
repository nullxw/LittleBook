//
//  OfficeViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "OfficeViewController.h"
#import "LBSectionView.h"
#import "ExtensionKit.h"

@interface OfficeViewController ()

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;

@end

@implementation OfficeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sectionView.separateLineColor = [UIColor colorWithR:246 g:245 b:243 a:1.0];
    _sectionView.sectionNumber = 3;
}

- (IBAction)back:(id)sender
{
    [self closeViewController:self
                     animated:YES
                   completion:nil];
}

@end
