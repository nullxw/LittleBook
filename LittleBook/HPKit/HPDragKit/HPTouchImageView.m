//
//  HPTouchImageView.m
//  HPTextView
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//
#import "HPTouchImageView.h"

@interface HPTouchImageView ()<UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    CGPoint _startCenter;
    CGPoint _startPoint;
    CGRect  _startRect;
    
    BOOL _isEditMode;
    
    UIButton *_deleteButton;
    
    UITapGestureRecognizer *_doubleTap;
    UIPinchGestureRecognizer *_pinchGesture;
    UILongPressGestureRecognizer *_longPressGesture;
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

- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    self.userInteractionEnabled = TRUE;
    [self registerGestures];
}
- (void)registerGestures
{
    _doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    _doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTap];
    
    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    _pinchGesture.delegate = self;
    [self addGestureRecognizer:_pinchGesture];
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:_longPressGesture];
}

#pragma mark - gesture handlers

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定要删除该附件吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
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
        
        _startRect = self.frame;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {

        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didEndOperateTouchImageView:)]) {
            [_touchDelegate didEndOperateTouchImageView:self];
        }
        return;
    } else {
        float w = _startRect.size.width * scale;
        float h = _startRect.size.height * scale;
        
        
        CGRect nextFrame = CGRectMake(_startCenter.x - w * 0.5, _startCenter.y - h * 0.5, w, h);
        
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(verifiedFrame:)]) {
            nextFrame = [_touchDelegate verifiedFrame:nextFrame];
        }
        
        self.frame = nextFrame;
    
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didOperateTouchImageView:)]) {
            [_touchDelegate didOperateTouchImageView:self];
        }
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    CGPoint toPoint = [gesture locationInView:self.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {

        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(willOperateTouchImageView:)]) {
            [_touchDelegate willOperateTouchImageView:self];
        }
    
        _pinchGesture.enabled = FALSE;
        
        [UIView animateWithDuration:0.1 animations:^{
            self.frame = CGRectInset(self.frame, -5, -5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.frame = CGRectInset(self.frame, 5, 5);
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        _startCenter = self.center;
        _startPoint = toPoint;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
        _pinchGesture.enabled = TRUE;
        
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didEndOperateTouchImageView:)]) {
            [_touchDelegate didEndOperateTouchImageView:self];
        }
        
    } else {
        
        CGPoint nextCenter= CGPointMake(_startCenter.x + toPoint.x - _startPoint.x, _startCenter.y + toPoint.y - _startPoint.y);
        
        float w = CGRectGetWidth(self.bounds);
        float h = CGRectGetHeight(self.bounds);
        
        CGRect nextFrame = CGRectMake(nextCenter.x - w * 0.5, nextCenter.y - h * 0.5, w, h);
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(verifiedFrame:)]) {
            nextFrame = [_touchDelegate verifiedFrame:nextFrame];
        }
        self.frame = nextFrame;
        
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didOperateTouchImageView:)]) {
            [_touchDelegate didOperateTouchImageView:self];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
    
        if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didRemoveTouchImageView:)]) {
            [_touchDelegate didRemoveTouchImageView:self];
        }
        [self removeFromSuperview];
        [_deleteButton removeFromSuperview];
        _deleteButton = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
