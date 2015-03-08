//
//  UIViewController+HPPresentViewExt.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPPresentView.h"

@interface UIViewController (HPPresentViewExt)

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion movingDirection:(HPPresentViewMovingDirection)direction;

@end
