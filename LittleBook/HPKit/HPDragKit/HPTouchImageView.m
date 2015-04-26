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
    CGPoint _startTranslate;
    CGFloat _startScale;
    CGFloat _startRotation;
    
    CGPoint _currentTranslate;
    CGFloat _currentScale;
    CGFloat _currentRotation;
    
    HPTouchImageViewState _startState;
    HPTouchImageViewState _endState;
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
    _startTranslate = CGPointZero;
    _startScale     = 1.0;
    _startRotation  = 0.0;
    self.userInteractionEnabled = TRUE;
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
    //...
    if (_delegate && [_delegate respondsToSelector:@selector(didClickTouchImageView:)]) {
        [_delegate didClickTouchImageView:self];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint translate = [gesture translationInView:self];
   
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _startState = _startState | HPTouchImageViewStatePan;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        _endState = _endState | HPTouchImageViewStatePan;
        _startTranslate = _currentTranslate;
    }
    
    [self updateTransform];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    float scale = gesture.scale;
    _currentScale = _startScale * scale;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _startState = _startState | HPTouchImageViewStatePinch;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        _endState = _endState | HPTouchImageViewStatePinch;
        _startScale = _currentScale;
    }
    
    [self updateTransform];
}

//- (void)handleRotate:(UIRotationGestureRecognizer *)gesture
//{
//    float rotation = gesture.rotation;
//    _currentRotation = _startRotation + rotation;
//    
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        _startState = _startState | HPTouchImageViewStateRotate;
//    }
//    
//    if (gesture.state == UIGestureRecognizerStateEnded) {
//        _endState = _endState | HPTouchImageViewStateRotate;
//        _startRotation = _currentRotation;
//    }
//    
//    [self updateTransform];
//}


- (void)updateTransform
{
    if (_currentScale == 0) {
        _currentScale = 1.0;
    }
    CGAffineTransform scaleTransform     = CGAffineTransformMakeScale(_currentScale, _currentScale);
    CGAffineTransform rotateTransform    = CGAffineTransformMakeRotation(_currentRotation);
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(_currentTranslate.x, _currentTranslate.y);
    self.transform = CGAffineTransformConcat(translateTransform, CGAffineTransformConcat(scaleTransform, rotateTransform));
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(DidTransformTouchImageView:)]) {
        [_delegate DidTransformTouchImageView:self];
    }
    
    if (_startState == _endState) {
        if (_delegate && [_delegate respondsToSelector:@selector(DidEndTransformTouchImageView:)]) {
            [_delegate DidEndTransformTouchImageView:self];
            
            _startState = 0;
            _endState   = 0;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
