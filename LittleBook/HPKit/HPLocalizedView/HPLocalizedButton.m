//
//  HPLocalizedButton.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/14.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPLocalizedButton.h"

@implementation HPLocalizedButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTitle:NSLocalizedString(self.titleLabel.text, nil) forState:UIControlStateNormal];
}
@end
