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
#import "LBPanelStyleManager.h"
#import "LBIndexInfoManager.h"
#import "HPTouchImageView.h"
#import "HPDragContainer.h"
#import "LBSectionView.h"

@interface LBDocumentEditViewController () <UITextFieldDelegate, UITextViewDelegate, HPDragContainerResponseDelegate, HPTouchImageViewProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL _isMediaEditViewVisible;
    
    NSMutableArray *_appendixs;
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
    
    // 1. init params
    [HPDragContainer shareContainer].responseDelegate = self;
    _appendixs = @[].mutableCopy;
    _appendixPaths = @[].mutableCopy;
    
    _isMediaEditViewVisible = FALSE;
    
    // 2. update UI
    _sectionView.sectionNumber = 3;
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
    
    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
    
    float offsetY = editViewHeight - 25;
    _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) - offsetY, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + offsetY);
    [_titleField becomeFirstResponder];
    
    [self updateInterfaceWithSettings];
    
    // 3. register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)updateInterfaceWithSettings
{
    PanelStyle *currentStyle = [[LBPanelStyleManager defaultManager] currentStyle];
    
    _contentView.backgroundColor = currentStyle.panelColor;
    _contentField.textColor = currentStyle.fontColor;
    _titleField.textColor   = currentStyle.fontColor;
}

#pragma mark - button events

- (IBAction)editButtonClicked:(UIButton *)sender
{
    _isMediaEditViewVisible = !_isMediaEditViewVisible;

    sender.enabled = FALSE;
    
    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    float halfToolBarHeight = 25;
    
    if (_editButton.tag == 0) {
        
        [_titleField resignFirstResponder];
        [_contentField resignFirstResponder];
        
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
- (IBAction)seperatorButtonClicked:(id)sender
{
    [_contentField insertSeperatorLineAtPoint:[_contentField cursourLocation]];
}

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
    if ([string isEqualToString:@"\n"]) {
        [_contentField becomeFirstResponder];
    }
    
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return TRUE;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [textView scrollRangeToVisible:range];
    return TRUE;
}
#pragma mark - HPDragContainerResponseDelegate

- (void)container:(HPDragContainer *)container didMoveItemToRect:(CGRect)rect
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    CGRect contentFieldFrame = [win convertRect:_contentField.frame fromView:_contentView];
    if (CGRectContainsRect(contentFieldFrame, container.draggedItem.frame)) {
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
    
    if (!_isMediaEditViewVisible) {
        UIImageView *draggedItem = (UIImageView *)container.draggedItem;
        
        HPTouchImageView *appendixView = [[HPTouchImageView alloc] initWithImage:draggedItem.image];
        appendixView.delegate = self;
        appendixView.frame    = [_contentField convertRect:draggedItem.frame fromView:win];
        appendixView.tag      = LB_DOCUMENT_APPENDIX_START_TAG + [[LBIndexInfoManager defaultManager] getAppendixID].intValue;
        
        [_appendixs addObject:appendixView];
        [_appendixPaths addObject:[UIBezierPath bezierPath]];
        [self DidTransformTouchImageView:appendixView];
        [_contentField addSubview:appendixView];
    }
    
    return !_isMediaEditViewVisible;
}

#pragma mark - HPTouchImageViewProtocol

- (void)DidTransformTouchImageView:(HPTouchImageView *)touchImageView
{
    CGRect frame = touchImageView.frame;
    float offset = _contentField.font.pointSize * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(frame.origin.x - offset, frame.origin.y - offset, frame.size.width + 2 * offset, frame.size.height)];
    NSInteger selectedIndex = [_appendixs indexOfObject:touchImageView];
    [_appendixPaths replaceObjectAtIndex:selectedIndex withObject:path];
    _contentField.textContainer.exclusionPaths = _appendixPaths;
    
}

- (void)DidEndTransformTouchImageView:(HPTouchImageView *)touchImageView
{
   
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
@end