//
//  EditViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#define LB_DOCUMENT_APPENDIX_START_TAG 999

#import "LBDocumentEditViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBDocumentAppendixEditView.h"
#import "LBPanelStyleManager.h"
#import "LBIndexInfoManager.h"
#import "HPTouchImageView.h"
#import "LBDragContainer.h"
#import "LBSectionView.h"


@interface LBDocumentEditViewController () <UITextFieldDelegate, UITextViewDelegate, LBDragContainerResponseDelegate, HPTouchImageViewProtocol>
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
    
    [LBDragContainer shareContainer].responseDelegate = self;
    
    _isMediaEditViewVisible = FALSE;
    
    _sectionView.sectionNumber = 3;
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
    
    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    
    _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
    
    float offsetY = editViewHeight - 25;
    _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) - offsetY, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + offsetY);
    
    [_titleField becomeFirstResponder];
    
    _appendixs = @[].mutableCopy;
    _appendixPaths = @[].mutableCopy;
    
    [self updateInterfaceWithSettings];
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
    
    [_titleField resignFirstResponder];
    [_contentField resignFirstResponder];
    sender.enabled = FALSE;
    
    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    float halfToolBarHeight = 25;
    if (_editButton.tag == 0) {
        // open edit panel
        [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            _editContainerView.frame = CGRectMake(0, halfToolBarHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
            
            float offsetY = editViewHeight - halfToolBarHeight;
            
            _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) + offsetY, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) - offsetY);
           
        } completion:^(BOOL finished) {
            _editButton.enabled = TRUE;
        }];
        
        
        
    } else {
        // close edit panel
        [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
            
            _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
            
            float offsetY = editViewHeight - halfToolBarHeight;
            _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) - offsetY, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + offsetY);
            
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [_contentField becomeFirstResponder];
    }
    
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_isMediaEditViewVisible) {
        [self editButtonClicked:_editButton];
    }
    return TRUE;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return TRUE;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_isMediaEditViewVisible) {
        [self editButtonClicked:_editButton];
    }
    return TRUE;
}

#pragma mark - LBDragContainerResponseDelegate

- (void)container:(LBDragContainer *)container didMoveItemToRect:(CGRect)rect
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

- (BOOL)draggedItemShouldLeftWhileContainerWillDismiss:(LBDragContainer *)container
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
@end