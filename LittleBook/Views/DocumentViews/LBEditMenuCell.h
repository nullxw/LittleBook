//
//  LBEditMenuCell.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kTextEditCellTitle  = @"kTextEditCellTitle";
static NSString *kTextEditCellIcon   = @"kTextEditCellIcon";
static NSString *kTextEditCellAction = @"kTextEditCellAction";


@interface LBEditMenuCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconView;

@end
