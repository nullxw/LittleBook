//
//  LoginViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/8.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LoginViewController.h"
//#import "UIViewController+HPPresentViewExt.h"
#import "LBSectionView.h"

#define LB_INPUT_FIELD_BORDER_COLOR [UIColor colorWithR:126 g:179 b:222 a:1.0].CGColor

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;
@property (weak, nonatomic) IBOutlet UIView *userNameContainer;
@property (weak, nonatomic) IBOutlet UIView *passwordContainer;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
    _sectionView.sectionNumber = 3;
    _userNameContainer.layer.cornerRadius = LB_COMMON_CORNER_RADIUS;
    _passwordContainer.layer.cornerRadius = LB_COMMON_CORNER_RADIUS;
    _userNameContainer.layer.borderWidth = LB_ONE_PX_SIZE;
    _passwordContainer.layer.borderWidth = LB_ONE_PX_SIZE;
    _userNameContainer.layer.borderColor = LB_INPUT_FIELD_BORDER_COLOR;
    _passwordContainer.layer.borderColor = LB_INPUT_FIELD_BORDER_COLOR;
    
}

//#pragma mark - HPPresentViewProtocol
//
//- (BOOL)presentView:(HPPresentView *)presentView shouldDismiss:(float)movingRatio
//{
//    return movingRatio > 0.25;
//}
//
//- (void)presentViewWillMovingFromSuperview:(HPPresentView *)presentView movingDriection:(HPPresentViewMovingDirection)direction
//{
//    [self dismissViewControllerAnimated:YES completion:nil movingDirection:direction];
//}

@end
