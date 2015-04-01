//
//  AccountViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AccountViewController.h"
#import "LBAccountManager.h"
#import "AccountCell.h"

@interface AccountViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataSource = [[LBAccountManager defaultManager] findAll];
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _tableView.frame = CGRectMake(0, CGRectGetMinY(_tableView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMinY(_tableView.frame));
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
    [cell setupCellWithAccount:_dataSource[indexPath.row]];
    return cell;

}

@end
