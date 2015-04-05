//
//  LBAccountCell.m
//  LittleBook
//
//  Created by hupeng on 15/4/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAccountCell.h"
#import "LBAccountAppendixFileManager.h"
#import "LBAccountEditViewController.h"
#import "LBAccountDetailManager.h"
#import "LBImagePreviewView.h"
#import "LBAppendixManager.h"
#import "Account.h"

@interface LBAccountCell () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIButton *_clickedButton;
    NSMutableArray *_appendixs;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *appendixButtons;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UITextField *costField;
@property (weak, nonatomic) IBOutlet UITextField *descField;

@end
@implementation LBAccountCell

- (void)awakeFromNib
{
    self.clipsToBounds = TRUE;
    _appendixs = [[NSMutableArray alloc] initWithCapacity:3];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_appendixs removeAllObjects];
    
    _descField.text = nil;
    _costField.text = nil;
    
    for (UIButton *button in _appendixButtons) {
        button.hidden = TRUE;
        [button setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    }
}

- (void)didMoveToSuperview
{
    //adjust UI position
    
    float margin = 15;
    float w = CGRectGetWidth(self.bounds);
    CGRect costFieldFrame = _costField.frame;
    costFieldFrame.size.width = w - margin - CGRectGetMinX(costFieldFrame);
    _costField.frame = costFieldFrame;
    
    CGRect descFieldFrame = _descField.frame;
    descFieldFrame.size.width = w - margin - CGRectGetMinX(descFieldFrame);
    _descField.frame = descFieldFrame;
    
    UIButton *centerButton = _appendixButtons[1];
    centerButton.center = CGPointMake(w * 0.5, centerButton.center.y);
    
    UIButton *rightButton = _appendixButtons[2];
    rightButton.center = CGPointMake(w - margin - CGRectGetWidth(rightButton.frame) * 0.5, rightButton.center.y);
}

- (BOOL)dataIsEmpty
{
    return (!_costField.text || _costField.text.length < 1) && _appendixs.count < 1;
}

- (BOOL)dataIsValid
{
    if (!_costField.text || _costField.text.length < 1) {
        return FALSE;
    }
    
    if (_appendixs.count < 1) {
        return FALSE;
    }
    return TRUE;
}

- (void)previewAppendix
{
    LBImagePreviewView *previewView = [LBImagePreviewView loadNibForCurrentDevice];
    previewView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:previewView];
    
    NSInteger selectedIndex = [_appendixButtons indexOfObject:_clickedButton];
    Appendix *appendix = _appendixs[selectedIndex];

    NSString *appendixFilePath = [[LBAccountAppendixFileManager defaultManager] pathForAppendix:appendix.appendixID];
    
    previewView.image = [UIImage imageWithContentsOfFile:appendixFilePath];
    
}
#pragma mark - button events

- (void)openCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.delegate = self;
    [_parentViewController presentViewController:picker animated:TRUE completion:nil];
}

- (void)saveButtonClicked:(id)sender
{
    if ([self dataIsEmpty]) {
        _parentViewController.isEditing = FALSE;
        return;
    }
    if (![self dataIsValid]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入金额或补充图片信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
   AccountDetail *accountDetail = [LBAccountDetailManager createAccountWithAppendixDatas:_appendixs description:_descField.text andCost:@(_costField.text.integerValue) parentID:_parentID];
    _parentViewController.account = accountDetail.parentAccount;
    _parentViewController.isEditing = FALSE;

}

- (IBAction)appendixButtonClicked:(UIButton *)sender
{
    _clickedButton = sender;
    if (_editMode) {
        [self openCamera];
    } else {
        [self previewAppendix];
    }
}

#pragma mark - properties

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    _costField.enabled = editMode;
    _descField.enabled = editMode;
    
    if (_editMode) {
        [_costField becomeFirstResponder];
        for (UIButton *button in _appendixButtons) {
            button.hidden = FALSE;
        }
    }
}

- (void)setAccountDetail:(AccountDetail *)accountDetail
{
    _accountDetail = accountDetail;
    
    if (accountDetail) {
        _appendixs = [LBAppendixManager appendixsOfAccountDetail:accountDetail.accountID].mutableCopy;
        
        for (int i = 0 ; i< _appendixs.count; i++) {
            Appendix *appendix = _appendixs[i];
            UIButton *button = _appendixButtons[i];
            button.hidden = FALSE;
            
            NSString *appendixFilePath = [[LBAccountAppendixFileManager defaultManager] pathForAppendixThumbnail:appendix.appendixID];
            [button setImage:[UIImage imageWithContentsOfFile:appendixFilePath] forState:UIControlStateNormal];
        }
        
        _costField.text = accountDetail.cost.stringValue;
        _descField.text = accountDetail.desc;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_descField]) {
        [self saveButtonClicked:nil];
        
        [textField resignFirstResponder];
    } else{
        [_descField becomeFirstResponder];
    }
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual:@"\n"]) {
        if ([textField isEqual:_descField]) {
            [self saveButtonClicked:nil];
            
            [textField resignFirstResponder];
        } else{
            [_descField becomeFirstResponder];
        }
    } else if ([string isEqual:@""]) {
        return TRUE;
        
    } else {
        if ([textField isEqual:_costField]) {
            
            if (![string isEqual:@"0"] && string.intValue == 0) {
                return FALSE;
            }
        }
    
    }

    return TRUE;
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    if (_clickedButton.tag < _appendixs.count) {
        [_appendixs replaceObjectAtIndex:_clickedButton.tag withObject:image];
    } else {
        [_appendixs addObject:image];
    }
    
    [_clickedButton setImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:TRUE completion:nil];
}

@end
