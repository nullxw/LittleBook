//
//  LBTimeLineView.h.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountEditViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBAccountDetailManager.h"
#import "LBTimeLineView.h"
#import "LBAccountCell.h"
#import "Account.h"

@interface LBAccountEditViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_accountDetails;
 
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LBTimeLineView *timeLineLabel;
@end

@implementation LBAccountEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate *date = [NSDate new];
    if (_account) {
        date = _account.createTime;
        _accountDetails = [LBAccountDetailManager findAllOfAccount:_account.accountID].mutableCopy;
    }
    
    _timeLineLabel.date = date;
    
    _isEditing = FALSE;
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    
    if (_account) {
        _accountDetails = [LBAccountDetailManager findAllOfAccount:_account.accountID].mutableCopy;
    }
    [_tableView reloadData];
    _tableView.scrollEnabled = !isEditing;
    
    CGRect toFrame = _tableView.frame;
    
    toFrame.origin.y = _isEditing ? CGRectGetMinY(_addButton.frame) : CGRectGetMaxY(_addButton.frame);
    
    _tableView.frame = toFrame;
    _addButton.hidden = _isEditing;
}


- (void)dismiss
{
    [self dismissViewControllerPresentFromBottonWithMovingDirection:HPPresentViewMovingDirectionDown];
}

#pragma mark - button events

- (IBAction)backButtonClicked:(UIButton *)sender
{
    if (!_isEditing) {
        [self dismiss];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要放弃当前的编辑内容吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (IBAction)addButtonClicked:(UIButton *)sender
{
    if (_isEditing) {
        return;
    }
    self.isEditing = TRUE;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _accountDetails.count + (_isEditing ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (_isEditing && indexPath.row == 0) {
        cell.parentViewController = self;
        cell.editMode = TRUE;
        cell.parentID = _account ? _account.accountID : nil;
    } else {
        NSInteger index = _isEditing ? indexPath.row - 1 : indexPath.row;
        cell.accountDetail = _accountDetails[index];
        cell.editMode = FALSE;
    }
    return cell;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismiss];
    }
}

@end
