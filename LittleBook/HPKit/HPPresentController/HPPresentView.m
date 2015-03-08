//
//  HPPresentView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//




#import "HPPresentView.h"

@interface HPPresentView ()
{
    CGPoint _startPoint;
    CGPoint _oriCenter;
    HPPresentViewMovingDirection _movingDirection;
    HPPresentViewMovingDirection _enabledMovingDirections;
}
@end

@implementation HPPresentView


- (void)awakeFromNib
{
    _enabledMovingDirections = HPPresentViewMovingDirectionDown |
                               HPPresentViewMovingDirectionLeft |
                               HPPresentViewMovingDirectionRight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _enabledMovingDirections = HPPresentViewMovingDirectionDown |
                                   HPPresentViewMovingDirectionLeft |
                                   HPPresentViewMovingDirectionRight;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _movingDirection = HPPresentViewMovingDirectionNone;
    _oriCenter  = self.center;
    _startPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    HPPresentViewMovingDirection direction = [self movingDirectionFromPoint:_startPoint toPoint:point];
    
    if (_movingDirection == HPPresentViewMovingDirectionNone) {
        _movingDirection = direction;
    }
    
    float dx = (point.x - _startPoint.x) * kHPPresentViewMovingRatio;
    float dy = (point.y - _startPoint.y) * kHPPresentViewMovingRatio;
    
    
    if ((_movingDirection & _enabledMovingDirections) == 0) {
        return;
    }
    
    if (_movingDirection == HPPresentViewMovingDirectionLeft || _movingDirection == HPPresentViewMovingDirectionRight) {
        self.center = CGPointMake(self.center.x + dx, self.center.y);
    } else {
        self.center = CGPointMake(self.center.x, self.center.y + dy);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(presentView:shouldDismiss:)]) {
        
        float movingRatio = 0.0;
        
        if (_movingDirection == HPPresentViewMovingDirectionLeft || _movingDirection == HPPresentViewMovingDirectionRight) {
            movingRatio = (self.center.x - _oriCenter.x)/CGRectGetWidth(self.bounds);
        } else {
            movingRatio = (self.center.y - _oriCenter.y)/CGRectGetHeight(self.bounds);
        }
        
        movingRatio = fabsf(movingRatio);
        
        if ([_delegate presentView:self shouldDismiss:movingRatio]) {
            if (_delegate && [_delegate respondsToSelector:@selector(presentViewWillMovingFromSuperview:movingDriection:)]) {
                [_delegate presentViewWillMovingFromSuperview:self movingDriection:_movingDirection];
            }
        } else {
            self.center = _oriCenter;
        }
        
    } else {
        self.center = _oriCenter;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (HPPresentViewMovingDirection)movingDirectionFromPoint:(CGPoint)startPoint toPoint:(CGPoint)toPoint
{
    float dx = toPoint.x - startPoint.x;
    float dy = toPoint.y - startPoint.y;
    float ratio = fabsf(dx) / fabsf(dy);
    
    if (ratio > 1) {
        return dx > 0 ? HPPresentViewMovingDirectionRight : HPPresentViewMovingDirectionLeft;
    } else {
        return dy > 0 ? HPPresentViewMovingDirectionDown : HPPresentViewMovingDirectionUp;
    }
}

- (void)enabledMovingDirections:(HPPresentViewMovingDirection)directions
{
    _enabledMovingDirections = directions;
}

@end
