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

//#pragma mark - HPPresentViewProtocol
//
//- (BOOL)presentView:(HPPresentView *)presentView shouldDismiss:(float)movingRatio
//{
//    return movingRatio > 0.25;
//}
//
//- (void)presentViewWillMovingFromSuperview:(HPPresentView *)presentView movingDriection:(HPPresentViewMovingDirection)direction
//{
//    [self dismissViewControllerAnimated:YES completion:nil movingDirection:direction];
//}

@end