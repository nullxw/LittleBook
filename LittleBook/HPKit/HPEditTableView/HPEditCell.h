//
//  HPEditCell.h
//  EdtiCellTest
//
//  Created by 胡鹏 on 15/5/3.
//  Copyright (c) 2015年 胡鹏. All rights reserved.
//

#import "HPAutoResizeCell.h"
#import "HPCallBackProtocol.h"

typedef enum {
    HPEditCellStatusLeftEditing,
    HPEditCellStatusRightEditing,
    HPEditCellStatusNormal
} HPEditCellStatus;

@interface HPEditCell : HPAutoResizeCell

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *leftButtons;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *rightButtons;

@property (nonatomic, assign) id<HPCallBackProtocol> delegate;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) BOOL disableEditing;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, assign) HPEditCellStatus currentStatus;


- (void)cancelEditing;

@end
