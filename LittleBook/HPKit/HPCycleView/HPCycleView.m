
#define HPCYCLEVIEW_PAGE_TAG_START 14567

#import "HPCycleView.h"

@interface HPCycleView()
{
    NSInteger _totalPages;
    NSInteger _currentPage;
    NSMutableArray *_cachePages;
    float _pageHeight;
}
@end

@implementation HPCycleView

- (void)awakeFromNib
{
    // Initialization code
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    _pageControl.userInteractionEnabled = NO;
    _currentPage = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_scrollView addGestureRecognizer:tap];
}

- (void)reloadData
{
    _totalPages = [_dataSource numberOfPages];
    
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (!_cachePages) {
        _cachePages = [[NSMutableArray alloc] initWithCapacity:3];
    }
    [_cachePages removeAllObjects];
    
    [self loadCurrentData];
}

- (void)loadCurrentData
{
    _pageControl.currentPage = _currentPage;
    
    // 特例
    if (_totalPages <= 1) {
        [self preparePageAtIndex:_currentPage-1];
        _pageControl.hidden = TRUE;
    } else {
        _pageControl.hidden = FALSE;
        [self preparePageAtIndex:_currentPage - 1];
        [self preparePageAtIndex:_currentPage];
        [self preparePageAtIndex:_currentPage + 1];
        _scrollView.contentSize = CGSizeMake(_pageWidth * 3, _pageHeight);
        [_scrollView setContentOffset:CGPointMake(_pageWidth, 0)];
    }
}

- (void)preparePageAtIndex:(NSInteger)index
{
    NSInteger validIndex = [self validPageValue:index];
    UIView *page = [_dataSource pageAtIndex:validIndex];
    
    if (!_pageWidth) {
        _pageWidth = CGRectGetWidth(page.bounds);
    }
    
    if (!_pageHeight) {
        _pageHeight = CGRectGetHeight(self.bounds);
    }
    float centerX = (index - _currentPage + 1.5) * _pageWidth;
    page.center = CGPointMake(centerX, _pageHeight * 0.5);

    [_scrollView addSubview:page];
    [_cachePages addObject:page];
}

- (NSInteger)validPageValue:(NSInteger)value
{
    if(value == -1) {
        value = _totalPages - 1;
    }
    if(value == _totalPages) {
        value = 0;
    }
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:_cachePages[1] atIndex:_currentPage];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*_pageWidth)) {
        
        _currentPage = [self validPageValue:_currentPage + 1];
        UIView *prePage = [_cachePages objectAtIndex:0];
        UIView *currentPage = [_cachePages objectAtIndex:1];
        UIView *lastPage = [_cachePages objectAtIndex:2];
        
        [prePage removeFromSuperview];
        [_cachePages removeAllObjects];
    
        float centerY = currentPage.center.y;
        
        currentPage.center = CGPointMake(_pageWidth * 0.5, centerY);
        lastPage.center = CGPointMake(_pageWidth * 1.5, centerY);
        
        [_cachePages addObject:currentPage];
        [_cachePages addObject:lastPage];
        
        [self preparePageAtIndex:_currentPage + 1];
        [_scrollView setContentOffset:CGPointMake(_pageWidth, 0)];
        
        if (_delegate && [_delegate respondsToSelector:@selector(currentPageIndexDidChanged)]) {
            [_delegate currentPageIndexDidChanged];
        }
    }
    
    //往上翻
    if(x <= 0) {
        _currentPage = [self validPageValue:_currentPage - 1];
        
        UIView *prePage = [_cachePages objectAtIndex:0];
        UIView *currentPage = [_cachePages objectAtIndex:1];
        UIView *lastPage = [_cachePages objectAtIndex:2];
        
        [lastPage removeFromSuperview];
        
        [_cachePages removeAllObjects];
        
        float centerY = currentPage.center.y;
        prePage.center = CGPointMake(_pageWidth * 1.5, centerY);
        currentPage.center = CGPointMake(2.5 *_pageWidth, centerY);
        
        [self preparePageAtIndex:_currentPage - 1];
        
        [_cachePages addObject:prePage];
        [_cachePages addObject:currentPage];

        [_scrollView setContentOffset:CGPointMake(_pageWidth, 0)];
        
        if (_delegate && [_delegate respondsToSelector:@selector(currentPageIndexDidChanged)]) {
            [_delegate currentPageIndexDidChanged];
        }
    }

    _pageControl.currentPage = _currentPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [_scrollView setContentOffset:CGPointMake(_pageWidth, 0) animated:YES];
}

@end
