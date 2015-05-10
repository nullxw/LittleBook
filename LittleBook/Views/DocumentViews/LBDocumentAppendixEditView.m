//
//  LBDocumentAppendixEditView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentAppendixEditView.h"
#import "LBImageEditView.h"
#import "LBEditMenuCell.h"
#import "LBPresentTheme.h"
#import "LBChartView.h"

static float kLBMediaContentOffsetY = 25;

@interface LBDocumentAppendixEditView ()<UITableViewDelegate ,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *_dataSource;

}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *mediaContentView;
@property (nonatomic, strong) LBImageEditView *imageEditView;
@property (nonatomic, strong) LBChartView *chartView;

@end

@implementation LBDocumentAppendixEditView

- (void)awakeFromNib
{
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDictionary *picInfo = @{kTextEditCellTitle : @"图片",
                              kTextEditCellIcon  : [UIImage imageNamed:@"pic_icon"],
                              kTextEditCellAction: ^(LBDocumentAppendixEditView *selfPoint) {

                                  if (selfPoint.imageEditView) {
                                      return;
                                  }
                                  if (selfPoint.chartView) {
                                      [selfPoint.chartView removeFromSuperview];
                                      selfPoint.chartView = nil;
                                  }
                                  
                                  if (!selfPoint.imageEditView) {
                                      selfPoint.imageEditView = [LBImageEditView loadNibForCurrentDevice];
                                  }
                                  
                                  CGRect imageEditViewFrame = _mediaContentView.frame;
                                  imageEditViewFrame.origin.y = CGRectGetMinY(imageEditViewFrame) + kLBMediaContentOffsetY;
                                  imageEditViewFrame.size.height = CGRectGetHeight(imageEditViewFrame) - kLBMediaContentOffsetY;
                                  selfPoint.imageEditView.frame = imageEditViewFrame;
                                  selfPoint.imageEditView.parentViewController = selfPoint.parentViewController;
                                  [selfPoint.mediaContentView addSubview:selfPoint.imageEditView];
                                  
                              }};
    
    [_dataSource addObject:picInfo];

    NSDictionary *chartInfo = @{kTextEditCellTitle : @"图表",
                                kTextEditCellIcon  : [UIImage imageNamed:@"chart_icon"],
                                kTextEditCellAction: ^(LBDocumentAppendixEditView *selfPoint) {
                                  
                                    if (selfPoint.chartView) {
                                        return;
                                    }
                                    if (selfPoint.imageEditView) {
                                        [selfPoint.imageEditView removeFromSuperview];
                                        selfPoint.imageEditView = nil;
                                    }
                                    
                                    if (!selfPoint.chartView) {
                                        selfPoint.chartView = [LBChartView loadNibForCurrentDevice];
                                    }
                                    
                                    selfPoint.chartView.theme = [CPTTheme themeNamed:kCPTLBPresentTheme];
                                    
                                    CGRect chartViewFrame = _mediaContentView.frame;
                                    chartViewFrame.origin.y = CGRectGetMinY(chartViewFrame) + kLBMediaContentOffsetY;
                                    chartViewFrame.size.height = CGRectGetHeight(chartViewFrame) - kLBMediaContentOffsetY;
                                    selfPoint.chartView.frame = chartViewFrame;
                                    [selfPoint.mediaContentView addSubview:_chartView];
                              }};
    
    [_dataSource addObject:chartInfo];
    
    NSDictionary *saveInfo = @{kTextEditCellTitle : @"另存",
                               kTextEditCellIcon  : [UIImage imageNamed:@"save_icon"],
                               kTextEditCellAction: ^(LBDocumentAppendixEditView *selfPoint) {
                                   
    
                
                                }};
    
    [_dataSource addObject:saveInfo];
    
    NSDictionary *shareInfo = @{kTextEditCellTitle : @"分享",
                                kTextEditCellIcon  : [UIImage imageNamed:@"share_icon"],
                                kTextEditCellAction: ^(LBDocumentAppendixEditView *selfPoint) {
                   
                               }};
    
    [_dataSource addObject:shareInfo];
    
    _tableView.scrollEnabled = FALSE;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBEditMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBEditMenuCell"];
    
    NSDictionary *cellInfo = _dataSource[indexPath.row];
    cell.titleLabel.text = cellInfo[kTextEditCellTitle];
    cell.iconView.image = cellInfo[kTextEditCellIcon];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellInfo = _dataSource[indexPath.row];
    
    void (^actionBlock)(LBDocumentAppendixEditView *selfPoint) = cellInfo[kTextEditCellAction];
    
    __block typeof(self) weakPoint = self;
    
    actionBlock(weakPoint);
}

#pragma mark - private methods

- (void)addImageToEdit:(UIImage *)imageToEdit
{
    NSDictionary *cellInfo = _dataSource[0];
    
    void (^actionBlock)(LBDocumentAppendixEditView *selfPoint) = cellInfo[kTextEditCellAction];
    
    __block typeof(self) weakPoint = self;
    
    actionBlock(weakPoint);
    
    _imageEditView.image = imageToEdit;
}

@end
