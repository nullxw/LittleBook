//
//  EditViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#define LB_DOCUMENT_APPENDIX_START_TAG 999
#define LB_DOCUMENT_CONTENT_OY_NOMARL  80
#define LB_DOCUMENT_CONTENT_OY_EDIT    275

#import "LBDocumentEditViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBDocumentAppendixEditView.h"
#import "LBAppendixFileManager.h"
#import "LBPanelStyleManager.h"
#import "LBIndexInfoManager.h"
#import "LBAppendixManager.h"
#import "LBDocumentContext.h"
#import "HPTouchImageView.h"
#import "HPDragContainer.h"
#import "LBSectionView.h"
#import "LBExportTemp.h"
#import "LBAppContext.h"
#import "Appendix.h"
#import "Document.h"

@interface LBDocumentEditViewController () <UITextFieldDelegate, UITextViewDelegate, HPDragContainerResponseDelegate, HPTouchImageViewProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    BOOL _isMediaEditViewVisible;
    
    NSMutableArray *_appendixs;
    NSMutableArray *_appendixViews;
    NSMutableArray *_appendixPaths;
}
@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;

@property (weak, nonatomic) IBOutlet LBDocumentAppendixEditView *editContainerView;

@end

@implementation LBDocumentEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _doc = [[LBDocumentContext defaultContext] prepareContext:_doc];
    // 1. init params
    [HPDragContainer shareContainer].responseDelegate = self;

    _isMediaEditViewVisible = FALSE;
    
    // 2. update UI
    _sectionView.sectionNumber = 3;
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;

    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
    
    float offsetY = editViewHeight - 25;
    _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) - offsetY, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + offsetY);
    
    [self updateInterfaceWithSettings];
    
    [self updateInterfaceWithDocument];
    
    // 3. register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)updateInterfaceWithSettings
{
    NSDictionary *settings = [LBAppContext context].settings;
    
    int fontSize = [settings[kLBFontSizeSetting] intValue];
    PanelStyle *currentStyle = [[LBPanelStyleManager defaultManager] currentStyle];
    
    _contentView.backgroundColor = currentStyle.panelColor;
    _contentField.textColor = currentStyle.fontColor;
    _titleField.textColor   = currentStyle.fontColor;
    
    _contentField.font = [UIFont fontWithName:_contentField.font.fontName size:fontSize];
    _titleField.font = [UIFont fontWithName:_titleField.font.fontName size:fontSize + 2];
}

- (void)updateInterfaceWithDocument
{
    _titleField.text = _doc.title;
    _contentField.text = _doc.content;
    
    NSArray *appendixs = [LBAppendixManager appendixs:_doc.documentID];
    
    _appendixs = [[NSMutableArray alloc] initWithCapacity:0];
    _appendixViews = [[NSMutableArray alloc] initWithCapacity:0];
    _appendixPaths = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (appendixs) {
        [_appendixs addObjectsFromArray:appendixs];
    }
    for (Appendix *appendix in appendixs) {
        [self creatAppendixViewWithAppendix:appendix];
    }
    
    _contentField.textContainer.exclusionPaths = _appendixPaths;
}

- (void)creatAppendixViewWithAppendix:(Appendix *)appendix
{
    NSString *appendixPath = [[LBAppendixFileManager defaultManager] pathForAppendix:appendix.appendixID];
    
    CGRect frame = CGRectFromString(appendix.frame);
    
    HPTouchImageView *appendixView = [[HPTouchImageView alloc] initWithFrame:frame];
    appendixView.image    = [UIImage imageWithContentsOfFile:appendixPath];
    appendixView.delegate = self;
    appendixView.tag      = LB_DOCUMENT_APPENDIX_START_TAG + appendix.appendixID.intValue;
    
    [_appendixViews addObject:appendixView];
    [_appendixPaths addObject:[self exclusionPathForFrame:frame]];

    [_contentField addSubview:appendixView];
}

- (UIBezierPath *)exclusionPathForFrame:(CGRect)frame
{
    float offset = _contentField.font.pointSize * 0.5;
    return [UIBezierPath bezierPathWithRect:CGRectMake(frame.origin.x - offset, frame.origin.y - offset, frame.size.width + 2 * offset, frame.size.height)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _doc.documentSize = NSStringFromCGSize(_contentView.frame.size);
}

#pragma mark - button events

- (IBAction)editButtonClicked:(UIButton *)sender
{
    _isMediaEditViewVisible = !_isMediaEditViewVisible;

    sender.enabled = FALSE;
    
    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    float halfToolBarHeight = 25;
    
    if (_editButton.tag == 0) {
        
        if (_titleField.isFirstResponder || _contentField.isFirstResponder) {
            // close key board if need
            [_titleField resignFirstResponder];
            [_contentField resignFirstResponder];
        } else {
            // else close it
            [self keyboardWillHide:nil];
        }
    
        // open edit panel
        [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            _editContainerView.frame = CGRectMake(0, halfToolBarHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);

        } completion:^(BOOL finished) {
            _editButton.enabled = TRUE;
        }];

    } else {
        if (_titleField.text.length == 0) {
            [_titleField becomeFirstResponder];
        } else {
            [_contentField becomeFirstResponder];
        }
    
        // close edit panel
        [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
            
            _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
            
        } completion:^(BOOL finished) {
            _editButton.enabled = TRUE;
        }];
    }
    _editButton.tag = !_editButton.tag;
}

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [[LBDocumentContext defaultContext] saveContext];
    [self dismissViewControllerPresentFromBottonWithMovingDirection:HPPresentViewMovingDirectionDown];
}

- (IBAction)audioButtonClicked:(id)sender
{
    
}

- (IBAction)cameraButtonClicked:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    [_titleField resignFirstResponder];
    [_contentField resignFirstResponder];
    
    UIImagePickerController *cameraViewController = [[UIImagePickerController alloc] init];
    cameraViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraViewController.delegate = self;
    [self presentViewController:cameraViewController animated:YES completion:^{
    
    }];
}
//- (IBAction)seperatorButtonClicked:(id)sender
//{
//    [_contentField insertSeperatorLineAtPoint:[_contentField cursourLocation]];
//}

- (IBAction)leftArrowButtonClicked:(id)sender
{
    [_contentField moveCursor:-1];
}

- (IBAction)rightArrowClicked:(id)sender
{
    [_contentField moveCursor:1];
}

- (IBAction)topArrowClicked:(id)sender
{
    [_contentField moveCursorToPreviousLine];
}

#pragma mark - UITextFieldDelegate

- (void)keyboardWillShow:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    float kbHeight = kbSize.height;

    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);

    if (_isMediaEditViewVisible) {
        
        _isMediaEditViewVisible = FALSE;
        // close edit panel
        [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
            
            _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
        } completion:^(BOOL finished) {
            _isMediaEditViewVisible = FALSE;
        }];
    }
    [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
    
        _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), LB_DOCUMENT_CONTENT_OY_NOMARL, CGRectGetWidth(_contentView.frame), CGRectGetHeight(self.view.bounds) - LB_DOCUMENT_CONTENT_OY_NOMARL - kbHeight);
        
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    float oY = LB_DOCUMENT_CONTENT_OY_NOMARL;
    if (_isMediaEditViewVisible) {
        oY = LB_DOCUMENT_CONTENT_OY_EDIT;
    }
    
    [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), oY, CGRectGetWidth(_contentView.frame), CGRectGetHeight(self.view.bounds) - oY);
        
    } completion:^(BOOL finished) {

    }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *title = textField.text;
    
    if ([string isEqualToString:@""] && title.length > 0) {
        title = [title substringToIndex:title.length - 1];
    } else if ([string isEqualToString:@"\n"]){
        [_contentField becomeFirstResponder];
    } else {
        title = [title stringByReplacingCharactersInRange:range withString:string];
    }
    _doc.title = title;
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return TRUE;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = textView.text;
    
    if ([text isEqualToString:@""] && content.length > 0) {
        content = [content substringToIndex:content.length - 1];
    } else if ([text isEqualToString:@"\n"]){
        [_contentField becomeFirstResponder];
    } else {
        content = [content stringByReplacingCharactersInRange:range withString:text];
    }
    
    _doc.content = content;
    return TRUE;
}
#pragma mark - HPDragContainerResponseDelegate

- (void)container:(HPDragContainer *)container didMoveItemToRect:(CGRect)rect
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    CGRect contentFieldFrame = [win convertRect:_contentField.frame fromView:_contentView];
    
    // 1.  图片进入文本区域
    if (CGRectContainsRect(contentFieldFrame, container.draggedItem.frame)) {
        
        // 1.1 隐藏编辑区
        if (_isMediaEditViewVisible) {
            [self editButtonClicked:nil];
        }
        
        CGRect frameInField = [_contentField convertRect:container.draggedItem.frame fromView:win];
        float offset = _contentField.font.pointSize * 0.5;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(frameInField.origin.x - offset, frameInField.origin.y - offset, frameInField.size.width + 2 * offset, frameInField.size.height)];
        NSMutableArray *tempPaths = _appendixPaths.mutableCopy;
        [tempPaths addObject:path];
        
        _contentField.textContainer.exclusionPaths = tempPaths;
        
    } else {
        _contentField.textContainer.exclusionPaths = _appendixPaths;
    
    }
}

- (BOOL)draggedItemShouldLeftWhileContainerWillDismiss:(HPDragContainer *)container
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    
    // 编辑菜单隐藏了说明 图片已经进入文本区域了
    if (!_isMediaEditViewVisible) {
        
        // creat Appendix
        
        UIImageView *draggedItem = (UIImageView *)container.draggedItem;

        CGRect appendixViewFrame = [_contentField convertRect:draggedItem.frame fromView:win];
        
        Appendix *appendix = [[LBDocumentContext defaultContext] addAppendix:draggedItem.image type:LBAppendixTypeImage];
//        appendix.frame = NSStringFromCGRect(draggedItem.frame);
        appendix.frame = NSStringFromCGRect(appendixViewFrame);
        
        [_appendixs addObject:appendix];
    
        [self creatAppendixViewWithAppendix:appendix];
        
//        HPTouchImageView *appendixView = [[HPTouchImageView alloc] initWithFrame:[_contentField convertRect:draggedItem.frame fromView:win]];
//        appendixView.image = draggedItem.image;
//        appendixView.delegate = self;
//        appendixView.tag      = LB_DOCUMENT_APPENDIX_START_TAG + appendix.appendixID.intValue;
//        
//        [_appendixViews addObject:appendixView];
//        [_appendixPaths addObject:[UIBezierPath bezierPath]];
//        [self didOperateTouchImageView:appendixView];
//        [_contentField addSubview:appendixView];
    }
    
    return !_isMediaEditViewVisible;
}

#pragma mark - HPTouchImageViewProtocol

- (void)didTapTouchImageView:(HPTouchImageView *)touchImageView
{
    [_contentField resignFirstResponder];
    [_titleField resignFirstResponder];
}

- (void)willOperateTouchImageView:(HPTouchImageView *)touchImageView
{
    //...
}

- (void)didOperateTouchImageView:(HPTouchImageView *)touchImageView
{
    NSLog(@"%@", NSStringFromCGPoint(_contentField.contentOffset));
    
    CGRect frame = touchImageView.frame;
    
    NSInteger selectedIndex = [_appendixViews indexOfObject:touchImageView];
    
    // update appendix
    Appendix *appendix = [_appendixs objectAtIndex:selectedIndex];
    appendix.frame = NSStringFromCGRect(frame);
    
    // update path infos
    UIBezierPath *path = [self exclusionPathForFrame:frame];
    [_appendixPaths replaceObjectAtIndex:selectedIndex withObject:path];
    
    // update content field
    _contentField.textContainer.exclusionPaths = _appendixPaths;
    
    NSLog(@"%@", NSStringFromCGPoint(_contentField.contentOffset));
}

- (void)didEndOperateTouchImageView:(HPTouchImageView *)touchImageView
{
//    [_contentField becomeFirstResponder];
}

#pragma mark -  UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:^{
        if (!_isMediaEditViewVisible) {
            [self editButtonClicked:_editButton];
            [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), LB_DOCUMENT_CONTENT_OY_EDIT, CGRectGetWidth(_contentView.frame), CGRectGetHeight(self.view.bounds) - LB_DOCUMENT_CONTENT_OY_EDIT);
                
            } completion:^(BOOL finished) {
                
            }];
        }
        [_editContainerView addImageToEdit:image];
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self exportAsPDF];
            break;
        case 1:
            [self exportAsImage];
            break;
        case 2:
            [self exportAsText];
            break;
        default:
            break;
    }
}

- (void)exportAsPDF
{
    LBExportTemp *temp = [LBExportTemp tempForPDF:self.doc];
    
}

- (void)exportAsImage
{

    
}
- (void)exportAsText
{

}
@end