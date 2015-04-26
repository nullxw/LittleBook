//
//  LBImageEditView.m
//  LittleBook
//
//  Created by hupeng on 15/4/5.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBImageEditView.h"
#import "LBImageFilterView.h"
#import "LBSectionView.h"
#import "HPDragContainer.h"

@interface LBImageEditView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, HPDragContainerResourceDelegate>
{
    UIImage *_originalImage;
    HPDragContainer *_canvas;
}

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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(openCanvas:)];
    [_imageView addGestureRecognizer:longPress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageView:) name:LB_DID_APPLY_IMAGE_FILTER_NOTIF object:nil];
}

- (void)setImage:(UIImage *)image
{
    _originalImage = image;
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.image = [image clipToSize:_imageView.frame.size];
}

- (void)updateImageView:(NSNotification *)notif
{
    _originalImage = notif.object;
    _imageView.image = _originalImage;
}

- (void)openAlbumPage
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self.parentViewController presentViewController:picker animated:TRUE completion:^{
        
    }];
}

- (void)openCanvas:(UILongPressGestureRecognizer *)gesture
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        _imageView.hidden = TRUE;
        
        _canvas = [HPDragContainer shareContainer];
        _canvas.resourceDelegate = self;
        [_canvas show];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
    
        [_canvas updateItemAtPoint:[gesture locationInView:keyWindow]];

    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        [_canvas hide];
        _canvas = nil;
    }
}

#pragma mark - menu button events

- (IBAction)deleteButtonClicked:(id)sender
{
    _originalImage = nil;
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = [UIImage imageNamed:@"add_icon"];
}

- (IBAction)detailMeunButtonClicked:(id)sender
{
    if (!_originalImage) {
        return;
    }
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    LBImageFilterView *imageEditView = [LBImageFilterView loadNibForCurrentDevice];
    imageEditView.image = _originalImage;
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
    _originalImage = info[@"UIImagePickerControllerOriginalImage"];

    self.image = _originalImage;

    [picker dismissViewControllerAnimated:TRUE completion:nil];
}


#pragma mark - HPDragContainerResourceDelegate

- (UIView *)setupItemOfContainer:(HPDragContainer *)container
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [win convertPoint:_imageView.center fromView:self];
    
    CGSize size = [_originalImage sizeForContainer:_imageView.frame.size];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    imageView.image = _originalImage;
    imageView.center = point;
    return imageView;
}

- (void)containerWillDismiss:(HPDragContainer *)container withDraggedItemBack:(BOOL)flag
{
    _imageView.hidden = FALSE;
    
    if (!flag) {
        [self deleteButtonClicked:nil];
    }
}
@end
