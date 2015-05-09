//
//  HPLocalizedLabel.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/14.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPLocalizedLabel.h"

@implementation HPLocalizedLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.text = NSLocalizedString(self.text, nil);
}
@end
