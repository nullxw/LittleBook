//
//  LBFileBrowserViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBFileBrowserViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBReadFileFileManager.h"
#import "LBDocumentManager.h"
#import "LBExportManager.h"
#import "LBSectionView.h"
#import "KVNProgress.h"
#import "ReadFile.h"

@interface LBFileBrowserViewController () <UIWebViewDelegate>
{
    LBExportManager *_exportManager;
}

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation LBFileBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 2. update UI
    _sectionView.sectionNumber = 3;
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadPDF];
}

- (void)loadPDF
{
    [KVNProgress showWithStatus:@"加载中/Loading..."];
    NSString *path = [[LBReadFileFileManager defaultManager] pathForReadFile:_readFile.fileID];
    
    NSURLRequest* pdfRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];

    [_webview loadRequest:pdfRequest];
}

#pragma mark - UIWebViewDelegate

- (IBAction)shareButtonClicked:(id)sender
{
    if (!_exportManager) {
        _exportManager = [[LBExportManager alloc] init];
    }
    
    Document *doc = [LBDocumentManager findByID:_readFile.fileID];
    [_exportManager openDoc:doc withHolder:self];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [KVNProgress showSuccess];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
}

#pragma mark - button events

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerPresentFromBottonWithMovingDirection:HPPresentViewMovingDirectionDown];
}



@end
