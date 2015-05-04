//
//  HPPasscodeInputView.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/7.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPFixedLengthPasscodeView.h"
#import "HPCommonMacro.h"
#import "HPLine.h"

@interface HPFixedLengthPasscodeView () <UITextFieldDelegate>
{
    NSMutableArray *_dots;
    NSInteger _currentInputIndex;
}
@end

@implementation HPFixedLengthPasscodeView

- (void)initPasscodeView
{
    [super initPasscodeView];
    
    // 1.clear subviews
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    
    self.layer.borderWidth = HP_ONE_PX_SIZE;
    self.layer.borderColor = [UIColor colorWithR:206 g:215 b:255 a:1.0].CGColor;
    _hiddenField.text = nil;
    _currentInputIndex = 0;
    self.passcodeLength = _passcodeLength;
}

- (void)prepareForErrorStatus
{
    [super prepareForErrorStatus];
    
    for (UIView *dot in _dots) {
        dot.backgroundColor = [UIColor redColor];
        dot.hidden = TRUE;
    }
}

- (NSString *)currentPasscode
{
    return _hiddenField.text;
}

- (void)setHiddenField:(UITextField *)hiddenField
{
    _hiddenField = hiddenField;
    hiddenField.delegate = self;
}

- (void)setPasscodeLength:(NSInteger)passcodeLength
{
    _passcodeLength = passcodeLength;
    
    for (UIView *line in self.subviews) {
        [line removeFromSuperview];
    }
    
    // 1.draw seperator line
    
    float h = CGRectGetHeight(self.bounds);
    float w = CGRectGetWidth(self.bounds);
    float cellWidth = w/passcodeLength;
    
    for (int i = 1; i < passcodeLength; i++) {
        HPLine *line = [HPLine verticalLineWithHeight:h];
        line.center = CGPointMake(i * cellWidth, h * 0.5);
        line.backgroundColor = [UIColor colorWithR:206 g:215 b:255 a:1.0];
        [self addSubview:line];
    }
    
    // 2.draw dots
    
    if (!_dots) {
        _dots = @[].mutableCopy;
    } else {
        [_dots removeAllObjects];
    }
    
    float dotSize = 0.25 * cellWidth;
    
    for (int i = 0; i < passcodeLength; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dotSize, dotSize)];
        dot.clipsToBounds = TRUE;
        dot.backgroundColor = [UIColor blackColor];
        dot.layer.cornerRadius = dotSize * 0.9;
        dot.center = CGPointMake((2 * i + 1) * cellWidth /2, h/2);
        dot.hidden = self.currentStateType != HPPasscodeStatusTypeShowPasscode;
        [self addSubview:dot];
        [_dots addObject:dot];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_currentInputIndex == _passcodeLength) {
        return FALSE;
    }
    if ([string isEqualToString:@"\n"]) {
        //...数字键盘 没有这一项
    } else if ([string isEqualToString:@""]) {
        
        UIView *dot = _dots[--_currentInputIndex];
        dot.hidden = TRUE;

    } else {
        UIView *dot = _dots[_currentInputIndex++];
        dot.hidden = FALSE;
        if (_currentInputIndex == _passcodeLength) {
            
            [self performSelector:@selector(updatePasscodeViewStatus) withObject:nil afterDelay:0.2];
        }
    }
    return TRUE;
}

@end
