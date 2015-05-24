//
//  LBNotificationEditViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBNotificationEditViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBNotificationManager.h"
#import "LBDatePickerCell.h"
#import "LBSectionView.h"

@interface LBNotificationEditViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;

@end

@implementation LBNotificationEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![LBNotificationManager defaultManager].preparedEntity) {
        [[LBNotificationManager defaultManager] prepareNotificationEntityWith:nil];
    }
}

#pragma - button events

- (void)dismissSelf
{
    [self dismissViewControllerPresentFromBottonWithMovingDirection:HPPresentViewMovingDirectionDown];
}

- (IBAction)dismiss:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定要放弃当前编辑的内容吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
   
}

- (IBAction)saveButtonClicked:(id)sender
{
    [[LBNotificationManager defaultManager] saveContext];
    [self dismissSelf];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    if (indexPath.row == 0) {
        cellHeight = 220;
    } else if (indexPath.row < 4 ) {
        cellHeight = 60;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LBDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataPickerCell"];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        cell.textLabel.text = @"标签/Label";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"openLabelEditPage" sender:self];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HP_ONE_PX_SIZE;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(tableView.bounds) - 30, HP_ONE_PX_SIZE)];
    line.backgroundColor = [UIColor colorWithR:71 g:166 b:223 a:1.0];
    return line;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[LBNotificationManager defaultManager] cleanContext];
        [self dismissSelf];
    }
}
@end
