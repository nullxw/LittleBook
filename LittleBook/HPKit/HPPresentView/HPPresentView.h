//
//  HPPresentView.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HPPresentViewMovingDirectionNone  = 1<<0,
    HPPresentViewMovingDirectionUp    = 1<<1,
    HPPresentViewMovingDirectionDown  = 1<<2,
    HPPresentViewMovingDirectionLeft  = 1<<3,
    HPPresentViewMovingDirectionRight = 1<<4
}HPPresentViewMovingDirection;

static const float kHPPresentViewMovingRatio = 0.25;

@class HPPresentView;

@protocol HPPresentViewProtocol <NSObject>

@optional
- (BOOL)presentView:(HPPresentView *)presentView shouldDismiss:(float)movingRatio;
- (void)presentViewWillMovingFromSuperview:(HPPresentView *)presentView movingDriection:(HPPresentViewMovingDirection)direction;

@end


@interface HPPresentView : UIView

@property (nonatomic, assign) IBOutlet id <HPPresentViewProtocol> delegate;

- (void)enabledMovingDirections:(HPPresentViewMovingDirection)directions;

@end
