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

@interface HPTouchImageView ()<UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    CGPoint _startCenter;
    CGRect  _startRect;
    
    BOOL _isDeleteMode;
    
    UIButton *_deleteButton;
    
    UIPanGestureRecognizer *_pan;
    UITapGestureRecognizer *_tap;
    UIPinchGestureRecognizer *_pinchGesture;
    UILongPressGestureRecognizer *_longPressGesture;
    
    BOOL _gestureEnd;
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

- (void)swtichToNormalModeIfNeeded
{
    if (_isDeleteMode) {
        [self toggleDeleteMode];
    }
}

- (void)toggleDeleteMode
{
    if (_isDeleteMode) {
        // switch to normal mode
        [_deleteButton removeFromSuperview];
        _deleteButton = nil;
    } else {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, 0, 40, 40);
        _deleteButton.center = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
        [_deleteButton setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:_deleteButton];
    }

    _isDeleteMode = !_isDeleteMode;
}

- (void)registerGestures
{
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:_pan];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:_tap];
    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    _pinchGesture.delegate = self;
    [self addGestureRecognizer:_pinchGesture];
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:_longPressGesture];
}

#pragma mark - gesture handlers

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (self.disableTap) {
        return;
    }
    
    [self swtichToNormalModeIfNeeded];
    
    if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(didTapTouchImageView:)]) {
        [_touchDelegate didTapTouchImageView:self];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if (self.disablePan) {
        return;
    }
    [self swtichToNormalModeIfNeeded];
    
    CGPoint toPoint = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _gestureEnd = FALSE;
        
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
        
        if (_gestureEnd) {
            return;
        }
        
        @synchronized(self) {
            _gestureEnd = TRUE;
        }
        
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
    
    [self swtichToNormalModeIfNeeded];
    
    float scale = gesture.scale;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        _gestureEnd = FALSE;
        
        
        
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
        
        if (_gestureEnd) {
            return;
        }
        
        @synchronized(self) {
            _gestureEnd = TRUE;
        }
        
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

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (_isDeleteMode) {
        return;
    }
    
    [self toggleDeleteMode];
}

- (void)deleteButtonClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定要删除该附件吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
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
