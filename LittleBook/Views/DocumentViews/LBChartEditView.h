//
//  LBChartEditView.h
//  LittleBook
//
//  Created by hupeng on 15/4/5.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBChartEditViewDelegate <NSObject>

- (void)didUpdateChartInfo:(NSDictionary *)chartInfo;

@end

@interface LBChartEditView : UIView

@property (nonatomic, strong) NSDictionary *chartInfo;

@property (nonatomic, assign) id <LBChartEditViewDelegate> delegate;

@end
