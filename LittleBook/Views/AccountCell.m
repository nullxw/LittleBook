//
//  AccountCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/21.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AccountCell.h"
#import "LBAccountTimeLineLabel.h"
#import "AccountAppendixFileManager.h"
#import "AccountAppendixCell.h"
#import "AppendixManager.h"
#import "Account.h"

@interface AccountCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UIView *realContentView;
@property (weak, nonatomic) IBOutlet LBAccountTimeLineLabel *timeLineLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation AccountCell

- (void)didMoveToSuperview
{
    float offsetX = 20;
    _realContentView.frame = CGRectMake(offsetX, CGRectGetMinY(_realContentView.frame), CGRectGetWidth(self.bounds) - 2 * offsetX, CGRectGetHeight(_realContentView.frame));
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setupCellWithAccount:(Account *)account
{
    _timeLineLabel.date = account.createTime;
    _costLabel.text = account.totalCost;
    _dataSource = [[AppendixManager defaultManager] appendixOfAccount:account.accountID];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AccountAppendixCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"appendixCell" forIndexPath:indexPath];
    
    Appendix *appendix = _dataSource[indexPath.row];
    NSString *appendixPath = [[AccountAppendixFileManager defaultManager] pathForAppendix:appendix.appendixID];
    cell.imageView.image = [UIImage imageWithContentsOfFile:appendixPath];
    return cell;
}
@end
