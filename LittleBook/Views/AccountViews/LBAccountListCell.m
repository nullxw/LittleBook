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

@interface LBAccountListCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UIView *realContentView;
@property (weak, nonatomic) IBOutlet LBTimeLineView *timeLineLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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
}

- (void)setAccount:(Account *)account
{
    _account = account;
    
    _timeLineLabel.date = account.createTime;
    _costLabel.text = account.totalCost.stringValue;
    _dataSource = [LBAppendixManager findByIDs:[account appendixIDs]];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBAccountAppendixCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"appendixCell" forIndexPath:indexPath];
    
    Appendix *appendix = _dataSource[indexPath.row];
    NSString *appendixPath = [[LBAccountAppendixFileManager defaultManager] pathForAppendix:appendix.appendixID];
    cell.imageView.image = [UIImage imageWithContentsOfFile:appendixPath];
    return cell;
}
@end
