//
//  HPTouchImageView.h
//  HPTextView
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPTouchImageView;

@protocol HPTouchImageViewProtocol <NSObject>

@optional
// tap
- (void)didTapTouchImageView:(HPTouchImageView *)touchImageView;

// resize
- (void)willOperateTouchImageView:(HPTouchImageView *)touchImageView;
- (void)didOperateTouchImageView:(HPTouchImageView *)touchImageView;
- (void)didEndOperateTouchImageView:(HPTouchImageView *)touchImageView;

- (CGRect)verifiedFrame:(CGRect)frame;

- (void)didRemoveTouchImageView:(HPTouchImageView *)touchImageView;

@end

@interface HPTouchImageView : UIImageView;

@property (nonatomic, assign) BOOL disablePinch;
@property (nonatomic, assign) BOOL disablePan;

@property (nonatomic, assign) IBOutlet id <HPTouchImageViewProtocol> touchDelegate;

@property (nonatomic, assign, readonly) CGRect rectBounds;

@end
