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
#import "CalendarView.h"

@interface CalendarViewController ()
{
    CalendarView *_calendarView;
}

@property (weak, nonatomic) IBOutlet HPRoundCornerView *notificationEditView;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
//    _sectionView.sectionNumber = 3;
    
    _calendarView = [CalendarView loadNibForCurrentDevice];
    _calendarView.frame = CGRectMake(20, 100, CGRectGetWidth(_calendarView.frame), CGRectGetHeight(_calendarView.frame));
    [self.view addSubview:_calendarView];
    
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerPresentFromRight];
}

 -(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // prepare for animation
    
    CGRect toRect = _notificationEditView.frame;
    CGRect fromRect = _notificationEditView.frame;
    fromRect.origin.x = CGRectGetWidth(self.view.bounds);
    _notificationEditView.frame = fromRect;
    
    // animating
    [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _notificationEditView.frame = toRect;
        
    } completion:^(BOOL finished) {
    }];
    
}

@end
