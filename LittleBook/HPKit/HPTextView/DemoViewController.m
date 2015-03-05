//
//  ViewController.m
//  HPTextView
//
//  Created by hupeng on 15/2/25.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "DemoViewController.h"
#import "HPTouchImageView.h"

@interface DemoViewController () <HPTouchImageViewProtocol, UITextViewDelegate>
{
    CGAffineTransform _transform;

}

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, weak) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet HPTouchImageView *touchImageView;
@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_touchImageView removeFromSuperview];
    [_textView addSubview:_touchImageView];
    [_container removeFromSuperview];
//    UIImage *image = [UIImage imageNamed:@"1.PNG"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width * 0.2, image.size.height * 0.2)];
//    imageView.userInteractionEnabled = TRUE;
//    imageView.image = image;
//    [_textView addSubview:imageView];
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imageView.frame];
//    _textView.textContainer.exclusionPaths = @[path];
//
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
//    [imageView addGestureRecognizer:pan];
    
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,140,140)];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_textView.text];
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    textAttachment.image = [UIImage imageNamed:@"1.PNG"];;
//
//    CGFloat oldWidth = textAttachment.image.size.width;
//    
//    //I'm subtracting 10px to make the image display nicely, accounting
//    //for the padding inside the textView
//    CGFloat scaleFactor = oldWidth / (_textView.frame.size.width - 10);
//    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
//    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//    [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withAttributedString:attrStringWithImage];
//    _textView.attributedText = attributedString;

}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)DidTransformTouchImageView:(HPTouchImageView *)touchImageView
{
    CGRect frame = touchImageView.frame;
//    _container.frame = frame;
    
//    frame = [self.view convertRect:frame toView:_textView];
//
    float offset = _textView.font.pointSize * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(frame.origin.x - offset, frame.origin.y - offset, frame.size.width + 2 * offset, frame.size.height)];
    _textView.textContainer.exclusionPaths = @[path];
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_textView.text];
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    textAttachment.image = touchImageView.image;
//
//    CGFloat scaleFactor = frame.size.width / _touchImageView.image.size.width;
//    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
//    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//    [attributedString replaceCharactersInRange:NSMakeRange(200, 1) withAttributedString:attrStringWithImage];
//    _textView.attributedText = attributedString;

}

- (void)DidEndTransformTouchImageView:(HPTouchImageView *)touchImageView
{
//    _transform = _touchImageView.transform;
//    _container.frame = touchImageView.frame;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    _touchImageView.userInteractionEnabled = FALSE;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
////    NSLog(@"%f",scrollView.contentOffset.y);
//    
//    float oY = scrollView.contentOffset.y;
//    
//    _touchImageView.transform = CGAffineTransformConcat(_transform, CGAffineTransformMakeTranslation(0, -oY));
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    float oY = scrollView.contentOffset.y;
//    
//    _touchImageView.transform = CGAffineTransformConcat(_transform, CGAffineTransformMakeTranslation(0, -oY));
//    
//    _touchImageView.userInteractionEnabled = TRUE;
//    _touchImageView.transform = _touchImageView.transform;
}
@end
