//
//  LBGuideViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/6/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBGuideViewController.h"

@interface LBGuideViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LBGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect bounds = [UIScreen mainScreen].bounds;
    int w = CGRectGetWidth(bounds);
    int h = CGRectGetHeight(bounds);
    
    for (int i = 0 ; i < 5; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"guidePage_%d_%d", i , w];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:bounds];
        guideView.image = image;
        guideView.center = CGPointMake(w/2, h * 0.5 + h * i);
        [_scrollView addSubview:guideView];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, h/2 + 4 * h, w, h/2);
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];

    _scrollView.contentSize = CGSizeMake(w, h * 5);

}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
