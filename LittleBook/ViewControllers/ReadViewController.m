//
//  ReadListViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "ReadViewController.h"
#import "LBSectionView.h"
#import "ExtensionKit.h"

@interface ReadViewController ()

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;

@end

@implementation ReadViewController

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
