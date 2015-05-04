//
//  LBAccountListCell.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPAutoResizeCell.h"
#import "HPCallBackProtocol.h"
@class Account;

@interface LBAccountListCell : HPAutoResizeCell

@property (nonatomic, weak) Account *account;

@property (nonatomic, assign) id <HPCallBackProtocol>delegate;

@end
