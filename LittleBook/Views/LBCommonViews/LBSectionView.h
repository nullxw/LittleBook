//
//  LBSectionView.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPRoundCornerView.h"

#ifdef IB_DESIGNABLE
IB_DESIGNABLE
#endif

@interface LBSectionView : HPRoundCornerView

#ifdef IBInspectable
@property (nonatomic, strong) IBInspectable UIColor * separateLineColor;
@property (nonatomic, strong) IBInspectable UIColor * borderColor;
@property (nonatomic, assign) IBInspectable float borderWidth;
@property (nonatomic, assign) IBInspectable NSUInteger sectionNumber;

#else
@property (nonatomic, strong) UIColor * separateLineColor;
@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) NSUInteger sectionNumber;
#endif

@end
