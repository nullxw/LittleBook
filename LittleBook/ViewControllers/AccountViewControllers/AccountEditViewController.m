//
//  AccountEditViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "AccountEditViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "AccountAppendixCell.h"
#import "AccountManager.h"

static NSInteger kAccountAppendixMaxCount = 5;

@interface AccountEditViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *_appendixs;
    NSInteger _selectedIndex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (weak, nonatomic) IBOutlet UITextField *descField;

@property (weak, nonatomic) IBOutlet UILabel *timeLineLabel;
@end

@implementation AccountEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardEvent:) name:UIKeyboardDidShowNotification object:nil];
    
    _appendixs = [[NSMutableArray alloc] init];
    
    
    UIToolbar* toolView = [[UIToolbar alloc] init];
    [toolView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"保存/Save"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(saveButtonClicked:)];
    
    [toolView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    _textField.inputAccessoryView = toolView;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
}
- (BOOL)dataIsEmpty
{
    return (!_textField.text || _textField.text.length < 1) && _appendixs.count < 1;
}
- (BOOL)dataIsValid
{
    if (!_textField.text || _textField.text.length < 1) {
        return FALSE;
    }
    
    if (_appendixs.count < 1) {
        return FALSE;
    }
    
    return TRUE;
}

- (void)openCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.delegate = self;
    [self presentViewController:picker animated:TRUE completion:nil];
}

- (void)dismiss
{
    [self dismissViewControllerPresentFromBottonWithMovingDirection:HPPresentViewMovingDirectionDown];
}

#pragma mark - notification handler

- (void)handleKeyboardEvent:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    float kbHeight = kbSize.height;
    
    _textFieldContainer.frame = CGRectMake(0, CGRectGetHeight(_contentView.bounds) - CGRectGetHeight(_textFieldContainer.frame) - kbHeight, CGRectGetWidth(_textFieldContainer.frame), CGRectGetHeight(_textFieldContainer.frame));
}

#pragma mark - button events

- (IBAction)backButtonClicked:(UIButton *)sender
{
    if ([self dataIsEmpty]) {
        [self dismiss];
        return;
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要放弃当前的编辑内容吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (IBAction)addButtonClicked:(UIButton *)sender
{
    _selectedIndex = -1;
    [self openCamera];
}

- (void)saveButtonClicked:(id)sender
{
    if (![self dataIsValid]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入金额或补充图片信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    Account *account = [[AccountManager defaultManager] createAccountWithAppendixDatas:_appendixs];
    account.totalCost = _textField.text;
    
      [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
          [self dismiss];
      }];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(_appendixs.count + 1, kAccountAppendixMaxCount);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"appendixCell";
    if (_appendixs.count < kAccountAppendixMaxCount && indexPath.row >= _appendixs.count) {
        cellIdentifier = @"addCell";
    }
    
    AccountAppendixCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if ([cellIdentifier isEqualToString:@"appendixCell"]) {
        cell.imageView.image = _appendixs[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [self openCamera];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    if (_selectedIndex >= 0) {
        [_appendixs replaceObjectAtIndex:_selectedIndex withObject:image];
    } else {
        [_appendixs addObject:image];
    }
    
    [_collection reloadData];
    
    [picker dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismiss];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField becomeFirstResponder];
    return TRUE;
}
@end
