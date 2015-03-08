//
//  UIViewController+HPPresentViewExt.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "UIViewController+HPPresentViewExt.h"

@implementation UIViewController (HPPresentViewExt)

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion movingDirection:(HPPresentViewMovingDirection)direction
{
    if (!flag) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if (completion) {
            completion();
        }
        return;
    }
    
    float w = CGRectGetWidth(self.view.bounds);
    float h = CGRectGetHeight(self.view.bounds);
    
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
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = toRect;
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if (completion) {
            completion();
        }
    }];
    
}
@end
