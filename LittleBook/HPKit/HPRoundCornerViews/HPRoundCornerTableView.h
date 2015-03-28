//
//  HPRoundCornerTableView.h
//  LittleBook
//
//  Created by hupeng on 15/3/28.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef IB_DESIGNABLE
IB_DESIGNABLE
#endif

@interface HPRoundCornerTableView : UITableView

#ifdef IBInspectable
@property (nonatomic, assign) IBInspectable float cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor * borderColor;
@property (nonatomic, assign) IBInspectable float borderWidth;

#else
@property (nonatomic, assign) float cornerRadius;
@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, assign) float borderWidth;
#endif

@end
