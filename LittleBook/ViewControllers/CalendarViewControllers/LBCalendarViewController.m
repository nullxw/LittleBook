//
//  LBCalendarViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBCalendarViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBNotificationEditViewController.h"
#import "LBNotificationCell.h"
#import "LBNotificationManager.h"
#import "CalendarView.h"

@interface LBCalendarViewController () <UITableViewDelegate, UITableViewDataSource>
{
    CalendarView *_calendarView;
    NSMutableArray *_dataSource;
    CGRect _notificationEditViewOriginalFrame;
}

@property (weak, nonatomic) IBOutlet UIView *notificationEditView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LBCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _notificationEditViewOriginalFrame = CGRectZero;
    _calendarView = [CalendarView loadNibForCurrentDevice];
    _calendarView.frame = CGRectMake(20, 100, CGRectGetWidth(_calendarView.frame), CGRectGetHeight(_calendarView.frame));
    [self.view addSubview:_calendarView];
    
    [self.view bringSubviewToFront:_notificationEditView];
}

 -(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (CGRectEqualToRect(_notificationEditViewOriginalFrame, CGRectZero)) {
        
        _notificationEditViewOriginalFrame = _notificationEditView.frame;
        
        CGRect fromRect = _notificationEditView.frame;
        fromRect.origin.x = CGRectGetWidth(self.view.bounds);
        _notificationEditView.frame = fromRect;
        
        // animating
        [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _notificationEditView.frame = _notificationEditViewOriginalFrame;
            
        } completion:^(BOOL finished) {
        }];
    }
    
    _dataSource = [[LBNotificationManager defaultManager] findAllOfToday].mutableCopy;
    [_tableView reloadData];
}


#pragma - button events

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerPresentFromRight];
}

- (IBAction)shiftNotificationListView:(UIButton *)sender
{
    if (sender.tag == 0) {
        
        CGRect toRect = _notificationEditView.frame;
        
        toRect.origin.y = CGRectGetMinY(_calendarView.frame);
        toRect.size.height = CGRectGetMaxY(_notificationEditView.frame) - toRect.origin.y;
        
        [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _notificationEditView.frame = toRect;
            
        } completion:^(BOOL finished) {
        }];
        
    } else {
        [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
            _notificationEditView.frame = _notificationEditViewOriginalFrame;
        }];
    }
    
    sender.tag = sender.tag ^ 1;
}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setupWithNotification:_dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[LBNotificationManager defaultManager] prepareNotificationEntityWith:_dataSource[indexPath.row]];
    [self performSegueWithIdentifier:@"openNotifEditPage" sender:self];
}
@end
