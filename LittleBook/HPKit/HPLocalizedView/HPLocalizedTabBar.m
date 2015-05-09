//
//  HPLocalizedTabBar.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/29.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPLocalizedTabBar.h"

@implementation HPLocalizedTabBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITabBarItem *item = (UITabBarItem *)obj;
        [item setTitle:NSLocalizedString(item.title, nil)];
    }];
}
@end
