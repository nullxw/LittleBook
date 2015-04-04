
//
//  HPCycleView.h
//  snapgrab
//
//  Created by hupeng on 14-11-25.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.

#import <UIKit/UIKit.h>

@class HPCycleView;

@protocol HPCycleViewDelegate <NSObject>

@optional
- (void)didClickPage:(UIView *)cell atIndex:(NSInteger)index;

- (void)currentPageIndexDidChanged;

@end

@protocol HPCycleViewDataSource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end

@interface HPCycleView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet id <HPCycleViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <HPCycleViewDataSource> dataSource;

@property (nonatomic, assign) float pageWidth;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentPage;

- (void)reloadData;

@end


