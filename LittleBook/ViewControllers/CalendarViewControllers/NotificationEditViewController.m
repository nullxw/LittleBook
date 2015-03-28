//
//  NotificationEditViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NotificationEditViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "NotificationManager.h"
#import "LBDatePickerCell.h"
#import "LBSectionView.h"

@interface NotificationEditViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;

@end

@implementation NotificationEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NotificationManager defaultManager] prepareNotificationEntity];
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
- (IBAction)didSelectDate:(UIDatePicker *)sender
{
    [NotificationManager defaultManager].preparedEntity.fireDate = sender.date;
}

- (IBAction)saveButtonClicked:(id)sender
{
    [[NotificationManager defaultManager] saveContext];
    [self dismissSelf];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    NSString *cellID = @"detailCell";
    
    switch (indexPath.row) {
        case 0:
            cellID = @"dataPickerCell";
            break;
        case 3:
            cellID = @"switchCell";
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"标签/Label";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"铃声/Bell";
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"openLabelEditPage" sender:self];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[NotificationManager defaultManager] cleanContext];
        [self dismissSelf];
    }
}
@end
