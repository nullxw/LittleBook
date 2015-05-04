//
//  LockView.m
//  LockDemo
//
//  Created by 胡鹏 on 3/30/15.
//  Copyright (c) 2013 HUPENG. All rights reserved.
//
#import "HPLockView.h"

@interface HPLockView()
{
    float _pointRadius;
    float _lineWidth;
    NSMutableArray *_responseAreas;
    CGPoint _lastSelectedPoint;
    
    /**
     *	_maskImageView used to show moving lines
     *  _canvasView only show the static image
     */
    UIImageView *_maskImageView;
    UIImageView *_canvasView;
}

@property (nonatomic, strong) NSMutableArray *selectedIndexs;

@end

@implementation HPLockView

- (NSString *)currentPasscode
{
    return [self.passcodeStorePolicy passcodeFromOutput:_selectedIndexs];
}

- (void)prepareForErrorStatus
{
    [super prepareForErrorStatus];
    
    self.userInteractionEnabled = FALSE;
    
    // 1.clear subviews
    for (UIView *subView in [self subviews]) {
        if ([subView isEqual:_canvasView]) {
            continue;
        }
        
        [subView removeFromSuperview];
    }
    
    int maxIndex =(int)(_selectedIndexs.count - 1);
    
    for (int i = maxIndex; i >= 0; i--) {
        NSInteger index = [_selectedIndexs[i] integerValue];
        [_selectedIndexs removeLastObject];
        [self didSelectPointAtIndex:index];
    }
}

- (void)didEndInputing
{
    _maskImageView.image = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    _lastSelectedPoint = [touch locationInView:self];

    /**
     *	if touch point in one of the response areas, selected the Circle
     *  else not response
     */ 
    NSInteger index = [self validPointIndex:_lastSelectedPoint];
    
    if (index == NSNotFound) {
        _lastSelectedPoint = CGPointZero;
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passcodeViewDidBeginInput:)]) {
        [self.delegate passcodeViewDidBeginInput:self];
    }
    
    [self selectPointAtIndex:index];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1. if start point is not in response areas,return
    if (CGPointEqualToPoint(_lastSelectedPoint,CGPointZero)) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    // 2. drawing line from the last selected point while moving
    
    [self drawLineFromPoint:_lastSelectedPoint toPoint:currentPoint];
    
    // 3. check touch point is in one of the circle or not
    NSInteger index = [self validPointIndex:currentPoint];

    if (index != NSNotFound) {
        [self selectPointAtIndex:index];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (CGPointEqualToPoint(_lastSelectedPoint,CGPointZero)) {
        return;
    }
    [self updatePasscodeViewStatus];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


#pragma mark - private methods

/**
 *	rest lock view - clear interface and reset parameters
 */
- (void)initPasscodeView
{
    [super initPasscodeView];

    // 1.clear subviews
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    
    // 2.clear imageView and maskImageView
    if (!_canvasView) {
        _canvasView = [[UIImageView alloc] initWithFrame:self.bounds];
        _canvasView.backgroundColor = [UIColor clearColor];
    }
    _canvasView.image = nil;
    _canvasView.frame = self.bounds;
    [self addSubview:_canvasView];
    
    
    if (!_maskImageView) {
        
        _maskImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _maskImageView.backgroundColor = [UIColor clearColor];
    }
    _maskImageView.image = nil;
    _maskImageView.frame = self.bounds;
    [self addSubview:_maskImageView];
    
    _canvasView.clipsToBounds = FALSE;
    _maskImageView.clipsToBounds = FALSE;
    
    // 3.init parameters
    
    if (!_responseAreas) {
        _responseAreas = [[NSMutableArray alloc] initWithCapacity:9];
    }
    
    if (!_selectedIndexs) {
        _selectedIndexs = [[NSMutableArray alloc] initWithCapacity:9];
    }
    
    [_responseAreas removeAllObjects];
    [_selectedIndexs removeAllObjects];
    
    _lastSelectedPoint = CGPointZero;

    UIColor *fillColor = [UIColor colorWithRed:149.0/255.0 green:213.0/255.0 blue:240.0/255.0 alpha:1.0];
    _lineWidth   = 6.0;
    _pointRadius = 22.0;
    int pointNumber = 9;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    [_canvasView.image drawInRect:self.bounds];
    
    [self drawBackgroundLinesInContext:context];
    
    // 4. draw nine point
    for (int i = 0 ; i< pointNumber; i++) {
        
        CGPoint center = [self pointCenterAtIndex:i];
        // 4.1 draw one point
        [self drawPoint:@{@"radius"    : @(_pointRadius),
                          @"center"    : NSStringFromCGPoint(center),
                          @"fillColor" : fillColor}
              inContext:context];
        
        // 4.2 record circle's response area,
        CGRect rect = CGRectMake(center.x-_pointRadius, center.y-_pointRadius, 2*_pointRadius, 2*_pointRadius);
        // u can set it bigger if needed
        CGRect responseRect = CGRectInset(rect, 0, 0);
        [_responseAreas addObject:NSStringFromCGRect(responseRect)];
    }
    _canvasView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (CGPoint)pointCenterAtIndex:(int)index
{
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    
    float size = MIN(w, h);
    
    float oX = (w - size)/2.0;
    float oY = (h - size)/2.0;
    
    float distance = (size - 6 * _pointRadius)/4.0;
 
    int line = index/3+1;
    int column = index%3+1;
    
    return CGPointMake(distance*column+ (2*column-1)*_pointRadius + oX, oY+distance*line+(2*line-1)*_pointRadius);
}

- (void)drawPoint:(NSDictionary *)pointInfo inContext:(CGContextRef)context
{
    float radius    = [pointInfo[@"radius"] floatValue];
    CGPoint center  = CGPointFromString(pointInfo[@"center"]);
    UIColor *fillColor = pointInfo[@"fillColor"];
    CGContextAddArc(context, center.x, center.y, radius, 0, 2*3.14, 0);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillPath(context);
   
}

- (void)drawBackgroundLinesInContext:(CGContextRef)context
{
    NSDictionary *lineInfo = @{@"lineWidth" : @(_lineWidth),
                               @"lineColor" : [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]};
    
    [self connect:[self pointCenterAtIndex:0] toPoint:[self pointCenterAtIndex:2] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:0] toPoint:[self pointCenterAtIndex:6] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:0] toPoint:[self pointCenterAtIndex:8] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:2] toPoint:[self pointCenterAtIndex:8] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:6] toPoint:[self pointCenterAtIndex:8] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:2] toPoint:[self pointCenterAtIndex:6] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:1] toPoint:[self pointCenterAtIndex:7] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:3] toPoint:[self pointCenterAtIndex:5] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:1] toPoint:[self pointCenterAtIndex:3] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:1] toPoint:[self pointCenterAtIndex:5] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:3] toPoint:[self pointCenterAtIndex:7] inContext:context withLineInfo:lineInfo];
    [self connect:[self pointCenterAtIndex:5] toPoint:[self pointCenterAtIndex:7] inContext:context withLineInfo:lineInfo];
}

- (void)connect:(CGPoint)startPoint toPoint:(CGPoint)endPoint inContext:(CGContextRef)context withLineInfo:(NSDictionary *)lineInfo
{
    UIColor *lineColor = lineInfo[@"lineColor"];
    float lineWidth    = [lineInfo[@"lineWidth"] floatValue];

    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextStrokePath(context);
    CGContextSaveGState(context);
}


#pragma mark - methods to handle event of selecting a point

- (NSInteger)validPointIndex:(CGPoint)point
{
    for (int i = 0; i<[_responseAreas count]; i++) {
        NSString *sRect = [_responseAreas objectAtIndex:i];
        
        if (CGRectContainsPoint(CGRectFromString(sRect), point)) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (BOOL)selectPointAtIndex:(NSInteger)index
{
    // 1.if current point has been selected ,return
    
    if (_selectedIndexs.count == 0) {
        [self didSelectPointAtIndex:index];
        return TRUE;
    }
    
    if ([_selectedIndexs containsObject:@(index)]) {
        return FALSE;
    }
    
    if (![self canConnectPointAtIndex:[[_selectedIndexs lastObject] intValue] andPointAtIndex:index]) {
        return FALSE;
    }

    NSInteger midPoint = [self findMiddlePointIndexBetweenPointIndex:[[_selectedIndexs lastObject] intValue] andPointIndex:index];
    
    if (midPoint != NSNotFound) {
         [self didSelectPointAtIndex:midPoint];
    }
    
    [self didSelectPointAtIndex:index];
    
    return TRUE;
}

- (BOOL)canConnectPointAtIndex:(NSInteger)startIndex andPointAtIndex:(NSInteger)endIndex
{
    CGPoint startPoint = CGPointMake(startIndex/3+1, startIndex%3+1);
    CGPoint endPoint = CGPointMake(endIndex/3+1, endIndex%3+1);
    
    //始末点一奇一偶 并且 差值不能被三整除 并且斜率！=0
    // 为长方形的对角线，不能连接
    if ((startIndex + endIndex)%2 == 1 && ABS(endIndex-startIndex)%3!=0 && (startPoint.x - endPoint.x)*(startPoint.y - endPoint.y) !=0) {
        return FALSE;
    }
    return TRUE;
}

- (NSInteger)findMiddlePointIndexBetweenPointIndex:(NSInteger)startIndex andPointIndex:(NSInteger)endIndex
{
    if (startIndex == endIndex) {
        return NSNotFound;
    }
    if ((startIndex + endIndex)%2!=0) {
        return NSNotFound;
    }
    
    NSInteger midIndex = (startIndex+endIndex)/2;
    
    // 算斜率
    CGPoint startPoint = CGPointMake(startIndex/3+1, startIndex%3+1);
    CGPoint endPoint = CGPointMake(endIndex/3+1, endIndex%3+1);
    CGPoint midPoint = CGPointMake(midIndex/3+1, midIndex%3+1);
    
    //3点不在一条直线上
    if ((midPoint.y - startPoint.y) != (endPoint.y - midPoint.y) || (midPoint.x - startPoint.x) != (endPoint.x - midPoint.x)) {
        return NSNotFound;
    }
    
    if ([_selectedIndexs containsObject:[NSNumber numberWithInteger:midIndex]]) {
        return NSNotFound;
    }
    return midIndex;
}

- (void)didSelectPointAtIndex:(NSInteger)index
{
    UIColor *selectedColor = [UIColor colorWithRed:119.0/255.0 green:196/255.0 blue:76/255.0 alpha:1.0];
    UIColor *errorColor = [UIColor colorWithRed:194.0/255.0 green:58.0/255.0 blue:63.0/255.0 alpha:1.0];
    
    NSString *sRect = _responseAreas[index];
    CGRect rect = CGRectFromString(sRect);
    
    _lastSelectedPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    // join line between two points
    if ([_selectedIndexs count]>0) {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
    
        NSString *sRect2 = _responseAreas[[[_selectedIndexs lastObject] intValue]];
        CGRect rect2 = CGRectFromString(sRect2);
    
        CGPoint startPoint =  CGPointMake(CGRectGetMidX(rect2), CGRectGetMidY(rect2));
        
        [_canvasView.image drawInRect:self.bounds];

        NSDictionary *lineInfo = @{@"lineWidth" : @(_lineWidth),
                                   @"lineColor" : self.isErrorStatus ? errorColor : selectedColor};
        [self connect:startPoint toPoint:_lastSelectedPoint inContext:context withLineInfo:lineInfo];
        
        _canvasView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        CGContextSaveGState(context);
        UIGraphicsEndImageContext();
    }
    
    UIView *selecteView = [[UIView alloc] initWithFrame:CGRectInset(rect, -2, -2)];

    float borderWidth = 6;
    selecteView.backgroundColor = [UIColor whiteColor];
    selecteView.layer.cornerRadius = CGRectGetWidth(selecteView.frame) * 0.5;
    selecteView.layer.borderWidth = borderWidth;
    selecteView.layer.borderColor = self.isErrorStatus ? errorColor.CGColor : selectedColor.CGColor;
    [self addSubview:selecteView];
    
    UIView *viewToAnimation = [[UIView alloc] initWithFrame:rect];
    viewToAnimation.layer.cornerRadius = CGRectGetWidth(viewToAnimation.frame) * 0.5;
    viewToAnimation.backgroundColor = self.isErrorStatus ? errorColor : selectedColor;
    [self addSubview:viewToAnimation];
    
    [UIView animateWithDuration:0.2 animations:^{
        viewToAnimation.alpha = 0.0;
        viewToAnimation.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [viewToAnimation removeFromSuperview];
    }];
    
    // 不加此判断照成死循环
    if (!self.isErrorStatus) {
        [_selectedIndexs addObject:[NSNumber numberWithInteger:index]];
    }
    
}

#pragma mark - methods to handle events of touch move

- (void)drawLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    UIColor *selectedColor = [UIColor colorWithRed:119.0/255.0 green:196/255.0 blue:76/255.0 alpha:1.0];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    NSDictionary *lineInfo = @{@"lineWidth" : @(_lineWidth),
                               @"lineColor" : selectedColor};
    [self connect:startPoint toPoint:endPoint inContext:context withLineInfo:lineInfo];

    _maskImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextSaveGState(context);
    UIGraphicsEndImageContext();
}

#pragma mark - static methods

- (void)setSelectedIndexs:(NSMutableArray *)selectedIndexs
{
    for (UIView *subView in [self subviews]) {
        if ([subView isEqual:_canvasView]) {
            continue;
        }
        
        [subView removeFromSuperview];
    }
    
    int maxIndex =(int)(selectedIndexs.count - 1);
    
    for (int i = maxIndex; i >= 0; i--) {
        NSInteger index = [selectedIndexs[i] integerValue];
        [selectedIndexs removeLastObject];
        [self didSelectPointAtIndex:index];
    }
}

+ (UIImage *)imageFromSelectedIndies:(NSArray *)indies
{
    HPLockView *lockView = [[HPLockView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    [lockView setSelectedIndexs:indies.mutableCopy];
    
    return lockView.toImage;
}
@end