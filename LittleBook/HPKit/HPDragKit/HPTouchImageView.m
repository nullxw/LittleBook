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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate = self;
    [self addGestureRecognizer:pinchGesture];
}

#pragma mark - gesture handlers

- (void)handleTap:(UITapGestureRecognizer *)gesture
{

    if (_delegate && [_delegate respondsToSelector:@selector(didTapTouchImageView:)]) {
        [_delegate didTapTouchImageView:self];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint toPoint = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(willOperateTouchImageView:)]) {
            [_delegate willOperateTouchImageView:self];
        }
    }
    
    self.center = CGPointMake(_startCenter.x + toPoint.x, _startCenter.y + toPoint.y);;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        _startCenter = self.center;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didEndOperateTouchImageView:)]) {
            [_delegate didEndOperateTouchImageView:self];
        }
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didOperateTouchImageView:)]) {
        [_delegate didOperateTouchImageView:self];
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    float scale = gesture.scale;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(willOperateTouchImageView:)]) {
            [_delegate willOperateTouchImageView:self];
        }
    }
    
    CGRect toFrame = CGRectZero;
    
    toFrame.size = CGSizeMake(_startRect.size.width * scale, _startRect.size.height * scale);
    
    self.frame  = toFrame;
    self.center = _startCenter;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        _startRect = self.frame;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didEndOperateTouchImageView:)]) {
            [_delegate didEndOperateTouchImageView:self];
        }
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didOperateTouchImageView:)]) {
        [_delegate didOperateTouchImageView:self];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
