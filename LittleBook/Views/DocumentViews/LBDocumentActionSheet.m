//
//  LBDocumentActionSheet.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//


#import "LBDocumentActionSheet.h"
#import "LBActionSheetCell.h"

@interface LBDocumentActionSheet () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation LBDocumentActionSheet

- (void)awakeFromNib
{
    [_tableView registerNib:[UINib loadNib:@"LBActionSheetCell"] forCellReuseIdentifier:@"cell"];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row < _dataSource.count) {
        
        NSDictionary *cellInfo = _dataSource[indexPath.row];
        
        cell.titleLabel.hidden = FALSE;
        cell.backIcon.hidden = TRUE;
        cell.titleLabel.text = cellInfo[@"title"];
        
    } else {
        cell.titleLabel.hidden = TRUE;
        cell.backIcon.hidden = FALSE;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataSource.count) {
        [self removeFromSuperview];
    } else {
        NSDictionary *cellInfo = _dataSource[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:LB_ACTION_NOTIF object:nil userInfo:@{LB_ACTION_TYPE_KEY:cellInfo[LB_ACTION_TYPE_KEY]}];
    }
}

@end
