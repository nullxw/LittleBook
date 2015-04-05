//
//  LBImageEditView.m
//  LittleBook
//
//  Created by hupeng on 15/4/5.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBImageEditView.h"
#import "LBSectionView.h"
#import "LBImageFilterView.h"

@interface LBImageEditView ()

@property (nonatomic, weak) IBOutlet LBSectionView *imageEditMenuView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LBImageEditView

- (void)awakeFromNib
{
    _imageEditMenuView.separateLineColor = [UIColor whiteColor];
    _imageEditMenuView.sectionNumber = 3;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageView:) name:LB_DID_APPLY_IMAGE_FILTER_NOTIF object:nil];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = [image scaleToSize:_imageView.frame.size];
}

- (void)updateImageView:(NSNotification *)notif
{
    _image = notif.object;
    _imageView.image = _image;
}

#pragma mark - menu button events

- (IBAction)deleteButtonClicked:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)detailMeunButtonClicked:(id)sender
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    LBImageFilterView *imageEditView = [LBImageFilterView loadNibForCurrentDevice];
    imageEditView.image = _imageView.image;
    imageEditView.frame = win.bounds;
    [win addSubview:imageEditView];
}

- (IBAction)insertButtonClicked:(id)sender
{
//    if (_delegate && [_delegate respondsToSelector:@selector(editView:insertImage:withImageInfo:)]) {
//        [_delegate editView:self
//                insertImage:_imageView.image
//              withImageInfo:@{kEditViewImageRectInfo : NSStringFromCGRect(_imageView.bounds),
//                              kEditViewImageCornerRadisInfo : @(LB_COMMON_CORNER_RADIUS)}];
//    }
}

@end
