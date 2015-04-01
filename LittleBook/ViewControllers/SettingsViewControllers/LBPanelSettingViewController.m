//
//  PanelLBSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBPanelSettingViewController.h"
#import "LBPanelStyleManager.h"
#import "LBPanelSettingCell.h"
#import "LBAppContext.h"

@interface LBPanelSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LBPanelSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *panelStyles = [LBPanelStyleManager defaultManager].panelStyles;
    NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int i = 0; i < panelStyles.count; i++) {
        PanelStyle *panelStyle = panelStyles[i];
        if ([panelStyle.styleName isEqualToString:[LBAppContext context].settings[kLBPanelSetting]]) {
            selectedPath = [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    
    [_tableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [LBPanelStyleManager defaultManager].panelStyles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBPanelSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBPanelSettingCell"];
    [cell setupCellWithPanelStyle:[LBPanelStyleManager defaultManager].panelStyles[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *settings = [LBAppContext context].settings;
    
    PanelStyle *panelStyle = [LBPanelStyleManager defaultManager].panelStyles[indexPath.row];
    settings[kLBPanelSetting] = panelStyle.styleName;
    [[LBAppContext context] updateSettings];
}

@end
