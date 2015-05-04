//
//  LBDocumentViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentViewController.h"
#import "LBDocumentManager.h"
#import "LBDocumentListCell.h"

@interface LBDocumentViewController () <UITableViewDataSource ,UITableViewDelegate>
{
    NSArray *_dataSource;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LBDocumentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataSource = [LBDocumentManager findAll];
}

#pragma mark - button events

- (IBAction)editButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"openEditPage" sender:self];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBDocumentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDocumentListCell"];
//    cell.document = _dataSource[indexPath.row];
    cell.tableView = tableView;
    return cell;
}
@end
