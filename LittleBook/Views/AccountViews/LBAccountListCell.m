//
//  LBAccountListCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountListCell.h"
#import "LBTimeLineView.h"
#import "LBAccountAppendixFileManager.h"
#import "LBAccountAppendixCell.h"
#import "LBAppendixManager.h"
#import "Account.h"

@interface LBAccountListCell ()
{
    NSArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UIView *realContentView;
@property (weak, nonatomic) IBOutlet LBTimeLineView *timeLineLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *appendixViews;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation LBAccountListCell

- (void)didMoveToSuperview
{
    float offsetX = 20;
    _realContentView.frame = CGRectMake(offsetX, CGRectGetMinY(_realContentView.frame), CGRectGetWidth(self.bounds) - 2 * offsetX, CGRectGetHeight(_realContentView.frame));
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    for (UIImageView *appendixView in _appendixViews) {
        appendixView.image = nil;
        appendixView.hidden = TRUE;
    }
}


- (void)setAccount:(Account *)account
{
    _account = account;
    
    _timeLineLabel.date = account.createTime;
    _costLabel.text = account.totalCost.stringValue;
    _dataSource = [LBAppendixManager findByIDs:[account appendixIDs]];
    
    for (int i = 0 ; i < _dataSource.count; i++) {
        Appendix *appendix = _dataSource[i];
        NSString *appendixFilePath = [[LBAccountAppendixFileManager defaultManager] pathForAppendixThumbnail:appendix.appendixID];
        UIImageView *appendixView = _appendixViews[i];
        appendixView.hidden = FALSE;
        appendixView.image = [UIImage imageWithContentsOfFile:appendixFilePath];
    }
}

@end
