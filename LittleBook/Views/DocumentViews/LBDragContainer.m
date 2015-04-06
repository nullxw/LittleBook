//
//  LBDragContainer.m
//  LittleBook
//
//  Created by hupeng on 15/4/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDragContainer.h"

@interface LBDragContainer ()
{
    BOOL _presented;
}

@end

@implementation LBDragContainer

+ (LBDragContainer *)shareContainer
{
    CREATE_SINGLETON_INSTANCE([[LBDragContainer alloc] init]);
}

- (void)updateItemAtPoint:(CGPoint)point
{
    [UIView animateWithDuration:0.1 animations:^{
        _draggedItem.center = point;
    }];
    
    [_responseDelegate container:self didMoveItemToRect:_draggedItem.frame];
}


- (void)show
{
    if (_presented) {
        return;
    }
    _presented = TRUE;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    _draggedItem = [_resourceDelegate setupItemOfContainer:self];
    [keyWindow addSubview:_draggedItem];
}

- (void)hide
{
    if (!_presented) {
        return;
    }
    _presented = FALSE;
    BOOL flag = [_responseDelegate draggedItemShouldLeftWhileContainerWillDismiss:self];
    [_resourceDelegate containerWillDismiss:self withDraggedItemBack:!flag];
    
    [_draggedItem removeFromSuperview];
    _draggedItem = nil;
}

@end
