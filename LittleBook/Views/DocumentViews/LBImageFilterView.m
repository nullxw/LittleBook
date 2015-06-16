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
    _imageView.image = image;
}

#pragma mark - button events

- (IBAction)doneButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LB_ACTION_NOTIF object:_imageView.image userInfo:@{LB_ACTION_TYPE_KEY : @(LBActionTypeApplyFilter)}];
    [self removeFromSuperview];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self removeFromSuperview];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filters.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *imageName = nil;
    
    if (indexPath.row == _filters.count) {
        imageName = @"filter_icon_5";
    } else {
        imageName = _filters[indexPath.row][@"image"];
    }
    
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == _filters.count) {
        _imageView.image = _image;
    } else {
        [[LBImageFilterManager defaultManager] applyFilter:indexPath.row withInputImage:_image completionHandler:^(UIImage *outputImage) {
            _imageView.image = outputImage;
        }];
    }
}

@end
