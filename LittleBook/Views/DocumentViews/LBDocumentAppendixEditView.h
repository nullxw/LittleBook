//
//  LBDocumentAppendixEditView
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPRoundCornerView.h"

//static NSString *kEditViewImageRectInfo        = @"kEditViewImageRectInfo";
//static NSString *kEditViewImageCornerRadisInfo = @"kEditViewImageCornerRadisInfo";

//@class LBDocumentAppendixEditView;

//@protocol LBDocumentAppendixEditViewProtocol <NSObject>
//
//@optional
//
//- (void)editView:(LBDocumentAppendixEditView *)editView insertImage:(UIImage *)image withImageInfo:(NSDictionary *)imageInfo;
//
//@end

@interface LBDocumentAppendixEditView : HPRoundCornerView

@property (nonatomic, weak) IBOutlet UIViewController *parentViewController;

@end

