//
//  HPTouchImageView.m
//  HPTextView
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

typedef enum {
    HPTouchImageViewStatePan    = 1<<0,
    HPTouchImageViewStatePinch  = 1<<1,
    HPTouchImageViewStateRotate = 1<<2,
} HPTouchImageViewState;

#import "HPTouchImageView.h"

@interface HPTouchImageView ()<UIGestureRecognizerDelegate>
{
    CGPoint _startCenter;
    CGRect  _startRect;
}

@end

@implementation HPTouchImageView

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    self.userInteractionEnabled = TRUE;
    _startCenter = self.center;
    _startRect   = self.frame;
    
    [self registerGestures];
}

- (void)registerGestures
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate = self;
    [self addGestureRecognizer:pinchGesture];

}

#pragma mark - gesture handlers

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (self.disableTap) {
        return;
    }
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didTapTouchImageView:)]) {
        [_touchDelegate didTapTouchImageView:self];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if (self.disablePan) {
        return;
    }
    CGPoint toPoint = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(willOperateTouchImageView:)]) {
            [_touchDelegate willOperateTouchImageView:self];
        }
    }
    
    CGPoint nextCenter= CGPointMake(_startCenter.x + toPoint.x, _startCenter.y + toPoint.y);
    
    float w = CGRectGetWidth(self.bounds);
    float h = CGRectGetHeight(self.bounds);
    
    CGRect nextFrame = CGRectMake(nextCenter.x - w * 0.5, nextCenter.y - h * 0.5, w, h);

    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(verifiedFrame:)]) {
        nextFrame = [_touchDelegate verifiedFrame:nextFrame];
    }
    
    
    self.frame = nextFrame;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        _startCenter = CGPointMake(CGRectGetMidX(nextFrame), CGRectGetMidY(nextFrame));
        
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didEndOperateTouchImageView:)]) {
            [_touchDelegate didEndOperateTouchImageView:self];
        }
        return;
    }
    
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didOperateTouchImageView:)]) {
        [_touchDelegate didOperateTouchImageView:self];
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    if (self.disablePinch) {
        return;
    }
    float scale = gesture.scale;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(willOperateTouchImageView:)]) {
            [_touchDelegate willOperateTouchImageView:self];
        }
    }
    
    
    float w = _startRect.size.width * scale;
    float h = _startRect.size.height * scale;
   
    
    CGRect nextFrame = CGRectMake(_startCenter.x - w * 0.5, _startCenter.y - h * 0.5, w, h);
    
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(verifiedFrame:)]) {
        nextFrame = [_touchDelegate verifiedFrame:nextFrame];
    }
    
    self.frame = nextFrame;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        _startRect = nextFrame;
        
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didEndOperateTouchImageView:)]) {
            [_touchDelegate didEndOperateTouchImageView:self];
        }
        return;
    }
    
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didOperateTouchImageView:)]) {
        [_touchDelegate didOperateTouchImageView:self];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
