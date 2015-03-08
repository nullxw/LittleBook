//
//  OfficeViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "OfficeViewController.h"
#import "LBSectionView.h"

@interface OfficeViewController ()

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;

@end

@implementation OfficeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
    _sectionView.sectionNumber = 3;
}

- (IBAction)back:(id)sender
{
    [self closeViewController:self
                     animated:YES
                   completion:nil];
}

@end
