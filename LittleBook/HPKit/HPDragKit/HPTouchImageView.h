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

// end operation
- (void)willOperateTouchImageView:(HPTouchImageView *)touchImageView;
- (void)didOperateTouchImageView:(HPTouchImageView *)touchImageView;
- (void)didEndOperateTouchImageView:(HPTouchImageView *)touchImageView;

@end

@interface HPTouchImageView : UIImageView;

@property (nonatomic, assign) IBOutlet id <HPTouchImageViewProtocol> delegate;

@property (nonatomic, assign, readonly) CGRect rectBounds;

@end
