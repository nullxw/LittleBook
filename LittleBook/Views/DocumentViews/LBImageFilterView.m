//
//  ImageEditView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBImageFilterView.h"
#import "LBImageFilterManager.h"
#import "LBSectionView.h"
#import "LBFilterCell.h"

@interface LBImageFilterView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *_filters;
}

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet LBSectionView *imageEditMenuView;

@end

@implementation LBImageFilterView

- (void)awakeFromNib
{
    [_collectionView registerNib:[UINib loadNib:@"LBFilterCell"] forCellWithReuseIdentifier:@"cell"];
    
    _filters = [LBImageFilterManager defaultManager].filters;
    
    _imageEditMenuView.separateLineColor = [UIColor whiteColor];
    _imageEditMenuView.sectionNumber = 2;
    
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    CGPoint center = _imageView.center;
    UIImage *scaledImage = [image scaleToSize:_imageView.frame.size];
    
    _imageView.image = scaledImage;
    _imageView.frame = CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.height);
    _imageView.center = center;
    
    //    _imageView.image = [image scaleToSize:<#(CGSize)#>];
}

#pragma mark - button events

- (IBAction)doneButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LB_DID_APPLY_IMAGE_FILTER_NOTIF object:_imageView.image];
    [self removeFromSuperview];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self removeFromSuperview];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.label.text = _filters[indexPath.row][@"displayname"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[LBImageFilterManager defaultManager] applyFilter:indexPath.row withInputImage:_image completionHandler:^(UIImage *outputImage) {
        _imageView.image = outputImage;
    }];
    
}

@end
