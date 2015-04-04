//
//  LBImagePreviewView.m
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBImagePreviewView.h"

@interface LBImagePreviewView () <HPPresentViewProtocol>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;


@end

@implementation LBImagePreviewView
- (void)awakeFromNib
{
    self.delegate = self;
    [self enabledMovingDirections:HPPresentViewMovingDirectionRAll];
}

- (void)setImage:(UIImage *)image
{
    CGSize imageViewSize = clipContainerSize(_imageView.frame.size, image.size);
    
    _imageView.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    _imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _imageView.image = image;

}
#pragma mark - HPPresentViewProtocol

- (BOOL)presentView:(HPPresentView *)presentView shouldDismiss:(float)movingRatio
{
    return movingRatio > 0.25;
}

- (void)presentViewWillMovingFromSuperview:(HPPresentView *)presentView movingDriection:(HPPresentViewMovingDirection)direction
{
    float w = CGRectGetWidth(self.bounds);
    float h = CGRectGetHeight(self.bounds);
    CGRect toRect = CGRectZero;
    
    
    switch (direction) {
        case HPPresentViewMovingDirectionDown:
            toRect = CGRectMake(0, h, w, h);
            break;
        case HPPresentViewMovingDirectionUp:
            toRect = CGRectMake(0, -h, w, h);
            break;
        case HPPresentViewMovingDirectionLeft:
            toRect = CGRectMake(-w, 0, w, h);
            break;
        case HPPresentViewMovingDirectionRight:
            toRect = CGRectMake(w, 0, w, h);
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
        self.frame = toRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
