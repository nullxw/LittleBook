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
- (void)didClickTouchImageView:(HPTouchImageView *)touchImageView;

- (void)DidTransformTouchImageView:(HPTouchImageView *)touchImageView;

- (void)DidEndTransformTouchImageView:(HPTouchImageView *)touchImageView;

@end

@interface HPTouchImageView : UIImageView;

@property (nonatomic, assign) IBOutlet id <HPTouchImageViewProtocol> delegate;

@property (nonatomic, assign, readonly) CGRect rectBounds;

@end
