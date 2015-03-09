//
//  LBSectionView.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBSectionView.h"
#import "HPLine.h"

@implementation LBSectionView

- (void)awakeFromNib
{
    self.clipsToBounds = TRUE;
    self.layer.cornerRadius = LB_COMMON_CORNER_RADIUS;
}

- (void)setSectionNumber:(NSUInteger)sectionNumber
{
    _sectionNumber = sectionNumber;
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[HPLine class]]) {
            [subview removeFromSuperview];
        }
    }
    
    float w = CGRectGetWidth(self.bounds);
    float h = CGRectGetHeight(self.bounds);
    
    for (int i = 1; i < sectionNumber; i++) {
        float offsetX = i * w/sectionNumber;
        HPLine *line = [HPLine verticalLineWithHeight:h];
        line.center = CGPointMake(offsetX, h * 0.5);
        line.backgroundColor = self.separateLineColor;
        [self addSubview:line];
    }
}

- (void)setSeparateLineColor:(UIColor *)separateLineColor
{
    _separateLineColor = separateLineColor;
    
    if (self.sectionNumber <= 1) {
        return;
    }
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[HPLine class]]) {
            subview.backgroundColor = separateLineColor;
        }
    }
    

}

@end
