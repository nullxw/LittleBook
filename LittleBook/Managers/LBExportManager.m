//
//  LBExportManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/17.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#define LB_AFTER_TIME 3.0

#import "LBExportManager.h"
#import "LBReadFileFileManager.h"
#import "LBReadFileManager.h"
#import "LBExportTemp.h"
#import "LBAppContext.h"
#import "KVNProgress.h"
#import "Document.h"

@interface LBExportManager ()<UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController *_documentViewController;
}
@end

@implementation LBExportManager

- (void)openDocImage:(UIImage *)image withHolder:(UIViewController *)holder
{
    NSString *filePath = [LBAppContext context].tempPath;
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    [data writeToFile:filePath atomically:TRUE];
    
    _documentViewController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _documentViewController.delegate = self;
    _documentViewController.UTI = @"public.image";
    _documentViewController.annotation = @{@"Little Book" : @"#Little Book"};
    [_documentViewController presentOpenInMenuFromRect:CGRectZero inView:holder.view animated:TRUE];
}

+ (void)exportDocument:(Document *)doc asPDF:(UIView *)docView
{
    ReadFile *readFile = [LBReadFileManager createReadFileFromDocument:doc];
    LBReadFileFileManager *fileManager = [LBReadFileFileManager defaultManager];
    NSString *filePath = [fileManager pathForReadFile:readFile.fileID];
    [LBExportManager createPDFfromUIView:docView saveToPath:filePath];
    
    [KVNProgress showSuccessWithStatus:@"导出完成,请在阅读小本中查看"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LB_AFTER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
}

+ (void)createPDFfromUIView:(UIView*)view saveToPath:(NSString*)filePath
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData(pdfData, view.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:pdfContext];
    
    UIGraphicsEndPDFContext();

    [pdfData writeToFile:filePath atomically:YES];
}

- (void)exportToLocal:(UIImage *)image
{
    [KVNProgress showWithStatus:@"导出中..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), @"exportToLocal");
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!error) {
            [KVNProgress showSuccessWithStatus:@"导出完成"];
        } else {
            [KVNProgress showErrorWithStatus:@"导出失败!"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LB_AFTER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });
    });
}
@end
