//
//  HPLocalizedSegControl.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/15.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPLocalizedSegControl.h"

@implementation HPLocalizedSegControl

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (int i = 0 ; i < self.numberOfSegments; i++) {
        NSString *title = [self titleForSegmentAtIndex:i];
        [self setTitle:NSLocalizedString(title, nil) forSegmentAtIndex:i];
    }
}

@end
