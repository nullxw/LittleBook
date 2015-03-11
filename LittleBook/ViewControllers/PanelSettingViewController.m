//
//  PanelSettingViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "PanelSettingViewController.h"
//#import "UIViewController+HPPresentViewExt.h"
#import "PanelStyleManager.h"
#import "PanelSettingCell.h"
#import "LBAppContext.h"

@interface PanelSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation PanelSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *panelStyles = [PanelStyleManager defaultManager].panelStyles;
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
    NSMutableDictionary *settings = [LBAppContext context].settings;
    
    PanelStyle *panelStyle = [PanelStyleManager defaultManager].panelStyles[indexPath.row];
    settings[kLBPanelSetting] = panelStyle.styleName;
    [[LBAppContext context] updateSettings];
}

@end
