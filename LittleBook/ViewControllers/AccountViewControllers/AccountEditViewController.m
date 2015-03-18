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
#import "Appendix.h"

@interface AccountEditViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *_appendixs;
    NSInteger _selectedIndex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation AccountEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardEvent:) name:UIKeyboardDidShowNotification object:nil];
    
    _appendixs = [[NSMutableArray alloc] init];
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

- (void)openCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.delegate = self;
    [self presentViewController:picker animated:TRUE completion:nil];
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
    [self dismissViewControllerPresentFromBottonWithMovingDirection:HPPresentViewMovingDirectionDown];
}

- (IBAction)addButtonClicked:(UIButton *)sender
{
    _selectedIndex = -1;
    [self openCamera];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(_appendixs.count + 1, 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"appendixCell";
    if (_appendixs.count < 5 && indexPath.row >= _appendixs.count) {
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
@end
