//
//  HPPresentViewController.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//


typedef enum {
    HPPresentViewControllerAnimationDirectionNone,
    HPPresentViewControllerAnimationDirectionFromTop,
    HPPresentViewControllerAnimationDirectionFromBottom,
    HPPresentViewControllerAnimationDirectionFromLeft,
    HPPresentViewControllerAnimationDirectionFromRight

} HPPresentViewControllerAnimationDirection;

#import <UIKit/UIKit.h>

@interface HPPresentViewController : UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                fromDirection:(HPPresentViewControllerAnimationDirection)direction
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion;

- (void)dismissViewControllerFromDirection:(HPPresentViewControllerAnimationDirection)direction
                                  animated:(BOOL)flag
                                completion:(void (^)(void))completion;
@end
