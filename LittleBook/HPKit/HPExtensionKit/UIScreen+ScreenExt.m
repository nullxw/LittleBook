//
//  ILS.m
//  snapgrab
//
//  Created by hupeng on 14-11-3.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "UIScreen+ScreenExt.h"

@implementation UIScreen (ScreenExt)

- (void)flashScreen
{
    float currentBrightness = self.brightness;
    [UIScreen mainScreen].brightness = 1.0;
    [self performSelector:@selector(backToNormalLight:) withObject:@(currentBrightness) afterDelay:0.5];
}

- (void)backToNormalLight:(NSNumber *)lightness
{
    [UIView animateWithDuration:1.0 animations:^{
        [UIScreen mainScreen].brightness = lightness.floatValue;
    }];
}
@end
