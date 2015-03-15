//
//  ImageEditView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBImageEditView.h"

@interface LBImageEditView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation LBImageEditView

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}

@end
