//
//  HPRoundCornerLabel.h
//  LittleBook
//
//  Created by 胡鹏 on 15/5/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef IB_DESIGNABLE
IB_DESIGNABLE
#endif

@interface HPRoundCornerLabel : UILabel

#ifdef IBInspectable
@property (nonatomic, assign) IBInspectable float cornerRadius;
#else
@property (nonatomic, assign) float cornerRadius;
#endif


@end
