//
//  LBAccountViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountViewController.h"
#import "LBAccountEditViewController.h"
#import "LBAccountListCell.h"
#import "LBAccountManager.h"

@interface LBAccountViewController () <UITableViewDataSource, UITableViewDelegate, HPCallBackProtocol>
{
    NSMutableArray *_dataSource;
    Account *_seletedAccount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LBAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _seletedAccount = nil;
    _dataSource     = [LBAccountManager findAll].mutableCopy;
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _tableView.frame = CGRectMake(0, CGRectGetMinY(_tableView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMinY(_tableView.frame));
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openEditPage"]) {
        LBAccountEditViewController *dvc = segue.destinationViewController;
        dvc.account = _seletedAccount;
    }
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBAccountListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBAccountListCell"];
    cell.delegate = self;
    cell.account = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _seletedAccount = _dataSource[indexPath.row];
    [self performSegueWithIdentifier:@"openEditPage" sender:self];
}

#pragma mark - HPCallBackProtocol

- (void)obj:(id)obj respondsToAction:(id)actionInfo
{
    LBAccountListCell *cell = obj;
    Account *account = cell.account;
    
    [_dataSource removeObject:account];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [LBAccountManager deleteAccount:account];
    
}
@end
