//
//  LBDocumentAppendixEditView
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPRoundCornerView.h"

@interface LBDocumentAppendixEditView : HPRoundCornerView

@property (nonatomic, weak) IBOutlet UIViewController *parentViewController;

- (void)addImageToEdit:(UIImage *)imageToEdit;

@end

