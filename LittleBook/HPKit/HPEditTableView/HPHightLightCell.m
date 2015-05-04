//
//  HPHightLightCell.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/22.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPHightLightCell.h"

@implementation HPHightLightCell

- (void)awakeFromNib
{
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Album_BG_Selected"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
