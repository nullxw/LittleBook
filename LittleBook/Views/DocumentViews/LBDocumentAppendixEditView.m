//
//  LBDocumentAppendixEditView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentAppendixEditView.h"
#import "LBDocumentActionSheet.h"
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

@property (nonatomic, strong) LBDocumentActionSheet *exportActionSheet;
@property (nonatomic, strong) LBDocumentActionSheet *openInActionSheet;
@property (nonatomic, strong) LBImageEditView *imageEditView;
@property (nonatomic, strong) LBChartView *chartView;

@end

@implementation LBDocumentAppendixEditView

- (CGRect)contentFrame
{
    CGRect frame = _mediaContentView.frame;
    frame.origin.y = CGRectGetMinY(frame) + kLBMediaContentOffsetY;
    frame.size.height = CGRectGetHeight(frame) - kLBMediaContentOffsetY;
    return frame;
}

- (void)cleanContentExcept:(id)excludedView
{
    if (_exportActionSheet && ![_exportActionSheet isEqual:excludedView]) {
        [_exportActionSheet removeFromSuperview];
        _exportActionSheet = nil;
    }
    if (_openInActionSheet && ![_openInActionSheet isEqual:excludedView]) {
        [_openInActionSheet removeFromSuperview];
        _openInActionSheet = nil;
    }
    if (_imageEditView && ![_imageEditView isEqual:excludedView]) {
        [_imageEditView removeFromSuperview];
        _imageEditView = nil;
    }
    if (_chartView && ![_chartView isEqual:excludedView]) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
}

- (void)awakeFromNib
{
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDictionary *picInfo = @{kTextEditCellTitle : @"图片",
                              kTextEditCellIcon  : [UIImage imageNamed:@"pic_icon"],
                              kTextEditCellAction: ^(LBDocumentAppendixEditView *selfPoint) {

                                  if (selfPoint.imageEditView) {
                                      return;
                                  }
                                  [self cleanContentExcept:selfPoint.imageEditView];
                      
                                  selfPoint.imageEditView = [LBImageEditView loadNibForCurrentDevice];
                                  selfPoint.imageEditView.frame = [selfPoint contentFrame];
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
                                    [self cleanContentExcept:selfPoint.chartView];
                                    
                                    selfPoint.chartView = [LBChartView loadNibForCurrentDevice];
                                    selfPoint.chartView.touchEnable = FALSE;
                                    selfPoint.chartView.theme = [CPTTheme themeNamed:kCPTLBPresentTheme];
                        
                                    selfPoint.chartView.frame = [selfPoint contentFrame];
                                    [selfPoint.mediaContentView addSubview:selfPoint.chartView];
                              }};
    
    [_dataSource addObject:chartInfo];
    
    NSDictionary *saveInfo = @{kTextEditCellTitle : @"另存",
                               kTextEditCellIcon  : [UIImage imageNamed:@"save_icon"],
                               kTextEditCellAction: ^(LBDocumentAppendixEditView *selfPoint) {
                                   
                                   if (selfPoint.exportActionSheet) {
                                       return;
                                   }
                                   
                                   NSArray *dataSource = @[@{@"title":@"图片",LB_ACTION_TYPE_KEY:@(LBActionTypeSaveToLocal)},
                                                                @{@"title":@"文档",LB_ACTION_TYPE_KEY:@(LBActionTypeSaveAsDoc)},
                                                                @{@"title":@"阅读",LB_ACTION_TYPE_KEY:@(LBActionTypeSaveAsPDF)}];
                                   
    
                                   [selfPoint cleanContentExcept:selfPoint.exportActionSheet];
                                   
                                   selfPoint.exportActionSheet  = [LBDocumentActionSheet loadNibForCurrentDevice];
                                   selfPoint.exportActionSheet.dataSource = dataSource;
                                   selfPoint.exportActionSheet.frame = [selfPoint contentFrame];
                                   [selfPoint.mediaContentView addSubview:selfPoint.exportActionSheet];
                                }};
    
    [_dataSource addObject:saveInfo];
    
    NSDictionary *shareInfo = @{kTextEditCellTitle : @"分享",
                                kTextEditCellIcon  : [UIImage imageNamed:@"share_icon"],
                                kTextEditCellAction: ^(LBDocumentAppendixEditView *selfPoint) {
                                    if (selfPoint.openInActionSheet) {
                                        return;
                                    }
                                    
                                    NSArray *dataSource = @[@{@"title":@"打开方式",LB_ACTION_TYPE_KEY:@(LBActionTypeOpenIn)}];
                                    
                                    [selfPoint cleanContentExcept:selfPoint.openInActionSheet];
                                    
                                    selfPoint.openInActionSheet  = [LBDocumentActionSheet loadNibForCurrentDevice];
                                    selfPoint.openInActionSheet.dataSource = dataSource;
                                    selfPoint.openInActionSheet.frame = [selfPoint contentFrame];
                                    [selfPoint.mediaContentView addSubview:selfPoint.openInActionSheet];
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
