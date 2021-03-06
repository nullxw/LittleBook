//
//  HPEditCell.m
//  EdtiCellTest
//
//  Created by 胡鹏 on 15/5/3.
//  Copyright (c) 2015年 胡鹏. All rights reserved.
//

#import "HPEditCell.h"

@interface HPEditCell () <UIScrollViewDelegate>
{
    CGRect _leftButtonsArea;
    CGRect _rightButtonsArea;
    
    float _offsetX;
    
    BOOL _canEditing;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *editCellContentView;

@end

@implementation HPEditCell

- (void)updateInterface
{
    _isAnmating = FALSE;
    
    int w = CGRectGetWidth(self.bounds);
    int h = CGRectGetHeight(self.bounds);
    
    _leftButtonsArea = CGRectMake(0, 0, 0, h);
    _rightButtonsArea = CGRectMake(w, 0, 0, h);
    
    for (UIButton *button in _leftButtons) {
        _leftButtonsArea.size.width += CGRectGetWidth(button.frame);
    }
    
    for (UIButton *button in _rightButtons) {
        _rightButtonsArea.size.width += CGRectGetWidth(button.frame);
        _rightButtonsArea.origin.x -= CGRectGetWidth(button.frame);
    }
    
    _offsetX = CGRectGetWidth(_leftButtonsArea);
    
    _scrollView.contentSize = CGSizeMake(w + CGRectGetWidth(_rightButtonsArea) + CGRectGetWidth(_leftButtonsArea), h);
    _scrollView.contentOffset = CGPointMake(_offsetX, 0);
    _editCellContentView.frame = CGRectMake(_offsetX, 0, w, h);

}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self updateInterface];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self updateInterface];
}

- (void)awakeFromNib
{
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    UITapGestureRecognizer *tapButtons = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButtons:)];
    
    [_scrollView addGestureRecognizer:tapButtons];
    
    UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
    
    [_editCellContentView addGestureRecognizer:tapCell];
    
    _isAnmating = FALSE;
    
    [tapButtons requireGestureRecognizerToFail:tapCell];
    
    for (UIGestureRecognizer *gesture in _scrollView.gestureRecognizers) {
        
        if([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [gesture requireGestureRecognizerToFail:tapButtons];
            break;
        }
    }
}

- (void)cancelEditing
{
    if (!_isEditing) {
        return;
    }
    [_scrollView scrollRectToVisible:_editCellContentView.frame animated:YES];
    self.isEditing = FALSE;
    self.currentStatus = HPEditCellStatusNormal;
    self.isAnmating = FALSE;
    
    [self cellDidEndEditing];
}

#pragma mark - event handlers

- (void)tapCell:(UITapGestureRecognizer *)tapGesture
{
    if (_isAnmating) {
        return;
    }
    if (self.isEditing) {
        [self cancelEditing];
        return;
    }
    [_tableView selectRowAtIndexPath:[_tableView indexPathForCell:self] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if (_tableView.delegate && [_tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_tableView.delegate tableView:_tableView didSelectRowAtIndexPath:[_tableView indexPathForCell:self]];
    }
}

- (void)tapButtons:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:self];
    
    if (CGRectContainsPoint(_leftButtonsArea, tapPoint)) {
        
        for (UIButton *button in _leftButtons) {
            if (CGRectContainsPoint(button.frame, tapPoint)) {
                [self actionButtonClicked:button];
                return;
            }
        }
        
    } else if (CGRectContainsPoint(_rightButtonsArea, tapPoint)) {
        for (UIButton *button in _rightButtons) {
            if (CGRectContainsPoint(button.frame, tapPoint)) {
                [self actionButtonClicked:button];
                return;
            }
        }
    }
    
}

- (void)actionButtonClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(obj:respondsToAction:)]) {
        [_delegate obj:self respondsToAction:sender];
    }
}

#pragma mark - methods to be implemented

- (void)cellWillBeginTranslate
{
    //...
}
- (void)cellDidEndEditing
{
    //...
}
- (void)cellDidBeginEditing
{
    //...
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [_tableView visibleCells];
    
    _canEditing = TRUE;
    for (HPEditCell *cell in visibleCells) {
        if (cell.isEditing) {
            [cell cancelEditing];
            _canEditing = FALSE;
            return;
        } else if (cell.isAnmating) {
            _canEditing = FALSE;
            return;
        }
    }
    
    if (self.disableEditing || !_canEditing || _tableView.isEditing) {
        return;
    }
    
    _isAnmating = TRUE;
    [self cellWillBeginTranslate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.disableEditing || !_canEditing || _tableView.isEditing) {
        scrollView.contentOffset = CGPointMake(_offsetX, 0);
        return;
    }
    float offsetX = scrollView.contentOffset.x;
    
    if (offsetX > _offsetX && CGRectGetWidth(_rightButtonsArea) == 0) {
        scrollView.contentOffset = CGPointMake(_offsetX, 0);
        _isAnmating = FALSE;
        [self cellDidEndEditing];
        return;
    }

    if (offsetX < _offsetX && CGRectGetWidth(_leftButtonsArea) == 0) {
        scrollView.contentOffset = CGPointMake(_offsetX, 0);
        _isAnmating = FALSE;
        [self cellDidEndEditing];
        return;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.disableEditing || !_canEditing || _tableView.isEditing) {
        *targetContentOffset = CGPointMake(_offsetX, 0);
        return;
    }
    
    float leftButtonsAreaWidth = CGRectGetWidth(_leftButtonsArea);
    float rightButtonsAreaWidth = CGRectGetWidth(_rightButtonsArea);
    
    if (velocity.x >= 0.5) {
        // swipe left - end up with showing right buttons
        *targetContentOffset = CGPointMake(leftButtonsAreaWidth + rightButtonsAreaWidth, 0);
    } else if (velocity.x <= -0.5) {
        // swipe right - end up with showing left buttons
        *targetContentOffset = CGPointMake(0, 0);
    } else {
        float targetOffsetX = (*targetContentOffset).x;
        
        if (targetOffsetX < leftButtonsAreaWidth * 0.5) {
            *targetContentOffset = CGPointMake(0, 0);
        } else if (targetOffsetX > leftButtonsAreaWidth + rightButtonsAreaWidth * 0.5) {
        
            *targetContentOffset = CGPointMake(leftButtonsAreaWidth + rightButtonsAreaWidth, 0);
        } else {
            *targetContentOffset = CGPointMake(_offsetX, 0);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isAnmating = FALSE;
    if (scrollView.contentOffset.x == _offsetX) {
        self.currentStatus = HPEditCellStatusNormal;
        self.isEditing = FALSE;
        [self cellDidEndEditing];
//        _tableView.scrollEnabled = TRUE;
    } else if (scrollView.contentOffset.x == 0) {
        self.currentStatus = HPEditCellStatusLeftEditing;
        self.isEditing = TRUE;
        [self cellDidBeginEditing];
//        _tableView.scrollEnabled = FALSE;
    } else {
        self.currentStatus = HPEditCellStatusRightEditing;
        self.isEditing = TRUE;
        [self cellDidBeginEditing];
//        _tableView.scrollEnabled = FALSE;
    }
}

@end
