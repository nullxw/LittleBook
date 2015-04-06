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

@interface LBImageEditView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet LBSectionView *imageEditMenuView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LBImageEditView

- (void)awakeFromNib
{
    _imageEditMenuView.separateLineColor = [UIColor whiteColor];
    _imageEditMenuView.sectionNumber = 3;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAlbumPage)];
    [_imageView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageView:) name:LB_DID_APPLY_IMAGE_FILTER_NOTIF object:nil];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.image = [image scaleToSize:_imageView.frame.size];
}

- (void)updateImageView:(NSNotification *)notif
{
    _image = notif.object;
    _imageView.image = _image;
}

- (void)openAlbumPage
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self.parentViewController presentViewController:picker animated:TRUE completion:^{
        
    }];


}

#pragma mark - menu button events

- (IBAction)deleteButtonClicked:(id)sender
{
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = [UIImage imageNamed:@"add_icon"];
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];

    self.image = image;

    [picker dismissViewControllerAnimated:TRUE completion:nil];
}

@end
