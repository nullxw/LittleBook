//
//  LBAccountListCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountListCell.h"
#import "LBAppendixFileManager.h"
#import "LBAccountAppendixCell.h"
#import "LBAppendixManager.h"
#import "LBTimeLineView.h"
#import "Account.h"

@interface LBAccountListCell ()
{
    NSArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet LBTimeLineView *timeLineLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *appendixViews;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end

@implementation LBAccountListCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    for (UIImageView *appendixView in _appendixViews) {
        appendixView.image = nil;
        appendixView.hidden = TRUE;
    }
    _deleteButton.hidden = TRUE;
}

- (void)awakeFromNib
{
    _deleteButton.hidden = TRUE;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    [self addGestureRecognizer:longPress];
}

- (void)setAccount:(Account *)account
{
    _account = account;
    
    _timeLineLabel.date = account.createTime;
    _costLabel.text = account.totalCost.stringValue;
    _dataSource = [LBAppendixManager findByIDs:[account appendixIDs]];
    
    for (int i = 0 ; i < _dataSource.count; i++) {
        Appendix *appendix = _dataSource[i];
        NSString *appendixFilePath = [[LBAppendixFileManager defaultManager] pathForAppendixThumbnail:appendix.appendixID];
        UIImageView *appendixView = _appendixViews[i];
        appendixView.hidden = FALSE;
        appendixView.image = [UIImage imageWithContentsOfFile:appendixFilePath];
    }
}

#pragma mark - event handlers

- (void)longPress
{
    _deleteButton.hidden = FALSE;
}

- (IBAction)deleteButtonClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(obj:respondsToAction:)]) {
        [_delegate obj:self respondsToAction:sender];
    }
}

@end
