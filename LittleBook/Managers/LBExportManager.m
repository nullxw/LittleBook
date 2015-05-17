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

- (void)openDoc:(Document *)doc withHolder:(UIViewController *)holder
{
    LBExportTemp *temp = [LBExportTemp loadNibForCurrentDevice];
    temp.frame = CGRectInset([UIScreen mainScreen].bounds, 10, 10);
    temp.document = doc;
    
    UIImage *image = [temp toImage];
    
    NSString *filePath = [LBAppContext context].tempPath;
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    [data writeToFile:filePath atomically:TRUE];
    
    _documentViewController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _documentViewController.delegate = self;
    _documentViewController.UTI = @"public.image";
    _documentViewController.annotation = @{@"Little Book" : @"#Little Book"};
    [_documentViewController presentOpenInMenuFromRect:CGRectZero inView:holder.view animated:TRUE];
}

+ (void)exportAsPDF:(Document *)doc withCompletionBlock:(void(^)())block
{
    LBExportTemp *temp = [LBExportTemp loadNibForCurrentDevice];
    temp.frame = CGRectInset([UIScreen mainScreen].bounds, 10, 10);
    temp.document = doc;
    
    LBReadFileFileManager *fileManager = [LBReadFileFileManager defaultManager];
    NSString *filePath = [fileManager pathForReadFile:doc.documentID];
    
    [LBExportManager createPDFfromUIView:temp saveToPath:filePath];
    [LBReadFileManager createReadFileFromDocument:doc];
    
    [KVNProgress showSuccessWithStatus:@"导出完成,请在阅读小本中查看/Completed"];

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

- (void)exportToLocal:(Document *)doc withCompletionBlock:(void(^)())block
{
    LBExportTemp *temp = [LBExportTemp loadNibForCurrentDevice];
    temp.frame = CGRectInset([UIScreen mainScreen].bounds, 10, 10);
    temp.document = doc;
    
    UIImage *image = [temp toImage];
    
    [KVNProgress showWithStatus:@"导出中/Exporting..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), @"exportToLocal");
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!error) {
            [KVNProgress showSuccessWithStatus:@"导出完成/Completed"];
        } else {
            [KVNProgress showErrorWithStatus:@"导出失败/Failed"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LB_AFTER_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });
        
    });
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
{
    
}

@end
