//
//  UIViewController+LBSegueExt.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPPresentView.h"

@interface UIViewController (LBSegueExt)

- (void)dismissViewControllerPresentFromBottonWithMovingDirection:(HPPresentViewMovingDirection)direction;

- (void)dismissViewControllerPresentFromRight;

@end
