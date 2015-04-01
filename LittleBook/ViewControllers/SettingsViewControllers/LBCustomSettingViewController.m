//
//  CustomLBSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBCustomSettingViewController.h"
#import "LBCustomSettingHeaderView.h"

@interface LBCustomSettingViewController () <UITableViewDelegate , UITableViewDataSource>
{
    NSInteger _expandedSection;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LBCustomSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _expandedSection = -1;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LBCustomSettingHeaderView *headerView = [LBCustomSettingHeaderView loadNibForCurrentDevice];
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(headerView.frame));
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"字体设置/Font Setting";
            break;
        case 1:
            title = @"插入设置/Insert Setting";
            break;
        default:
            break;
    }
    headerView.titleLabel.text = title;
    headerView.button.tag = section;
    [headerView.button addTarget:self action:@selector(shiftSection:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == _expandedSection ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = _expandedSection == 0 ? @"fontSettingCell" : @"insertSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}


#pragma mark - button event

- (void)shiftSection:(UIButton *)sender
{
    if (_expandedSection == sender.tag) {
        _expandedSection = -1;
    } else {
        _expandedSection = sender.tag;
    }
    [_tableView reloadData];
}

@end
