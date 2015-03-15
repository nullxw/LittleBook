//
//  LBEditView.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBRoundCornerView.h"

static NSString *kEditViewImageRectInfo        = @"kEditViewImageRectInfo";
static NSString *kEditViewImageCornerRadisInfo = @"kEditViewImageCornerRadisInfo";

@class LBEditView;

@protocol LBEditViewProtocol <NSObject>

@optional

- (void)editView:(LBEditView *)editView insertImage:(UIImage *)image withImageInfo:(NSDictionary *)imageInfo;

@end

@interface LBEditView : LBRoundCornerView

@property (nonatomic, weak) IBOutlet id <LBEditViewProtocol> delegate;
@property (nonatomic, weak) IBOutlet UIViewController *parentViewController;

@end
