//
//  ReadListViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "ReadViewController.h"
#import "LBSectionView.h"

@interface ReadViewController ()

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;

@end

@implementation ReadViewController

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
