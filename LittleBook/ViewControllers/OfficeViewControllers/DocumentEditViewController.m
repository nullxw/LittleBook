//
//  EditViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "DocumentEditViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBSectionView.h"
#import "LBEditView.h"

@interface DocumentEditViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;

@property (weak, nonatomic) IBOutlet LBEditView *editContainerView;


@end

@implementation DocumentEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sectionView.sectionNumber = 3;
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
    
    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    
    _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
    
    float offsetY = editViewHeight - 25;
    _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) - offsetY, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + offsetY);
    
    [_titleField becomeFirstResponder];
}

#pragma mark - button events

- (IBAction)editButtonClicked:(UIButton *)sender
{
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return TRUE;
}
@end