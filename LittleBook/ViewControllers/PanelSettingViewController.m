//
//  PanelSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "PanelSettingViewController.h"
//#import "UIViewController+HPPresentViewExt.h"
#import "PanelSettingCell.h"
#import "PanelStyleManager.h"

@interface PanelSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation PanelSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PanelStyleManager defaultManager].panelStyles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PanelSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"panelSettingCell"];
    [cell setupCellWithPanelStyle:[PanelStyleManager defaultManager].panelStyles[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
