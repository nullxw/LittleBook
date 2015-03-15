//
//  CalendarViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "CalendarViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBSectionView.h"

@interface CalendarViewController ()

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;


@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
    _sectionView.sectionNumber = 3;
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerPresentFromRight];
}

@end
