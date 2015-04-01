//
//  LBNotificaitonLabeViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/29.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBNotificaitonLabeViewController.h"
#import "LBNotificationManager.h"

@interface LBNotificaitonLabeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation LBNotificaitonLabeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _backgroundView.layer.borderWidth = LB_ONE_PX_SIZE;
    _backgroundView.layer.borderColor = [UIColor colorWithR:220 g:220 b:220 a:1.0].CGColor;
    [_inputField becomeFirstResponder];
    
    _inputField.text = [LBNotificationManager defaultManager].preparedEntity.label;
}

- (IBAction)dismissButtonClicked:(id)sender
{
    [LBNotificationManager defaultManager].preparedEntity.label = _inputField.text;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [LBNotificationManager defaultManager].preparedEntity.label = textField.text;
    [self dismissButtonClicked:nil];
    return YES;
}
@end
