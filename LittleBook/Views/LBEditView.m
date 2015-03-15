//
//  LBEditView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBEditView.h"
#import "LBSectionView.h"
#import "LBTextEditCell.h"
#import "LBImageEditView.h"
#import "HPTouchImageView.h"

@interface LBEditView ()
<
UITableViewDelegate ,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HPTouchImageViewProtocol
>
{
    NSMutableArray *_dataSource;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *mediaContentView;
@property (nonatomic, weak) IBOutlet LBSectionView *imageEditMenuView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation LBEditView

- (void)awakeFromNib
{
    _imageEditMenuView.hidden = TRUE;
    _imageView.hidden = TRUE;
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    _imageEditMenuView.separateLineColor = [UIColor colorWithRed:32.0/255.0 green:38.0/255.0 blue:56.0/255.0 alpha:1.0];
    _imageEditMenuView.sectionNumber = 3;
    
    NSDictionary *picInfo = @{kTextEditCellTitle : @"图片",
                              kTextEditCellIcon  : [UIImage imageNamed:@"pic_icon"],
                              kTextEditCellAction: ^(LBEditView *selfPoint) {
                                  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  picker.delegate = selfPoint;
                                  [selfPoint.parentViewController presentViewController:picker animated:TRUE completion:^{
                                      
                                  }];
                              }};
    
    [_dataSource addObject:picInfo];
    
    
    NSDictionary *chartInfo = @{kTextEditCellTitle : @"图表",
                                kTextEditCellIcon  : [UIImage imageNamed:@"chart_icon"],
                                kTextEditCellAction: ^(LBEditView *selfPoint) {
                                  
                                  
                                  
                              }};
    
    [_dataSource addObject:chartInfo];
    
    NSDictionary *saveInfo = @{kTextEditCellTitle : @"另存",
                               kTextEditCellIcon  : [UIImage imageNamed:@"save_icon"],
                               kTextEditCellAction: ^(LBEditView *selfPoint) {
                                    
                                    
                                    
                                }};
    
    [_dataSource addObject:saveInfo];
    
    NSDictionary *shareInfo = @{kTextEditCellTitle : @"分享",
                                kTextEditCellIcon  : [UIImage imageNamed:@"share_icon"],
                                kTextEditCellAction: ^(LBEditView *selfPoint) {
                                   
                                   
                                   
                               }};
    
    [_dataSource addObject:shareInfo];
    
    _tableView.scrollEnabled = FALSE;
    
}

//#pragma mark - meun view animaton
//
//- (void)hideMenuViewWithAnimation:(BOOL)flag
//{
//
//}
//
//- (void)showMenuView
//{
//    
//}

#pragma mark - menu button events

- (IBAction)deleteButtonClicked:(id)sender
{
    _imageView.image = nil;
    _imageView.hidden = TRUE;
    _imageEditMenuView.hidden = TRUE;
}

- (IBAction)detailMeunButtonClicked:(id)sender
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    LBImageEditView *imageEditView = [LBImageEditView loadNib];
    imageEditView.image = _imageView.image;
    imageEditView.frame = win.bounds;
    [win addSubview:imageEditView];
}

- (IBAction)insertButtonClicked:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editView:insertImage:withImageInfo:)]) {
        [_delegate editView:self
                insertImage:_imageView.image
              withImageInfo:@{kEditViewImageRectInfo : NSStringFromCGRect(_imageView.bounds),
                              kEditViewImageCornerRadisInfo : @(LB_COMMON_CORNER_RADIUS)}];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBTextEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBTextEditCell"];
    
    NSDictionary *cellInfo = _dataSource[indexPath.row];
    cell.titleLabel.text = cellInfo[kTextEditCellTitle];
    cell.iconView.image = cellInfo[kTextEditCellIcon];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellInfo = _dataSource[indexPath.row];
    
    void (^actionBlock)(LBEditView *selfPoint) = cellInfo[kTextEditCellAction];
    
    __block typeof(self) weakPoint = self;
    
    actionBlock(weakPoint);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    _imageView.image = image;
    
    _imageView.hidden = FALSE;
    
    _imageEditMenuView.hidden = FALSE;
    
    [picker dismissViewControllerAnimated:TRUE completion:nil];

}


#pragma mark - HPTouchImageViewProtocol


@end
