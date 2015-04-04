//
//  LBAccountCell.h
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountDetail, LBAccountEditViewController;

@interface LBAccountCell : UITableViewCell

@property (nonatomic, weak) AccountDetail *accountDetail;
@property (nonatomic, weak) LBAccountEditViewController *parentViewController;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, strong) NSString *parentID;

@end
