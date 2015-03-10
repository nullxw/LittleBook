//
//  PanelSettingCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/9.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "PanelSettingCell.h"
#import "PanelStyleManager.h"

@interface PanelSettingCell ()

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *checkBoxView;

@end

@implementation PanelSettingCell

- (void)awakeFromNib
{
    _descriptionLabel.clipsToBounds = TRUE;
    _descriptionLabel.layer.cornerRadius = LB_COMMON_CORNER_RADIUS;
    _descriptionLabel.layer.borderWidth  = LB_ONE_PX_SIZE;
    _descriptionLabel.layer.borderColor  = LB_BLUE_LINE_COLOR.CGColor;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    float offsetX = 20;
    _descriptionLabel.frame = CGRectMake(offsetX, CGRectGetMinY(_descriptionLabel.frame), CGRectGetWidth(self.bounds) - 2 * offsetX, CGRectGetHeight(_descriptionLabel.frame));
    _checkBoxView.frame = CGRectMake(CGRectGetMaxX(_descriptionLabel.frame) - 20, CGRectGetMaxY(_descriptionLabel.frame) - 20, CGRectGetWidth(_checkBoxView.frame), CGRectGetHeight(_checkBoxView.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    _checkBoxView.hidden = !selected;
}

- (void)setupCellWithPanelStyle:(PanelStyle *)panelStyle
{
    _descriptionLabel.text = panelStyle.panelDesc;
    _descriptionLabel.textColor = panelStyle.fontColor;
    _descriptionLabel.backgroundColor = panelStyle.panelColor;
}
@end
