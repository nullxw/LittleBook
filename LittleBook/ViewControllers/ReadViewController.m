//
//  ReadListViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "ReadViewController.h"
#import "LBDocumentListCell.h"

@interface ReadViewController () <UITableViewDataSource ,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBDocumentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDocumentListCell"];
    
    return cell;
}
@end
