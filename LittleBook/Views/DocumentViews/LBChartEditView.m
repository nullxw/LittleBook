//
//  LBChartEditView.m
//  LittleBook
//
//  Created by hupeng on 15/4/5.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBChartEditView.h"
#import "LBAnimatedBarChart.h"
#import "LBPresentTheme.h"
#import "LBSimpleTheme.h"
#import "LBSectionView.h"

@interface LBChartEditView () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet LBAnimatedBarChart *chartView;
@property (nonatomic, weak) IBOutlet LBSectionView *chartEditMenuView;

@end

@implementation LBChartEditView

- (void)awakeFromNib
{
    _chartEditMenuView.separateLineColor = [UIColor whiteColor];
    _chartEditMenuView.sectionNumber = 2;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    _chartView.theme = _theme;
}

#pragma mark - button events

- (IBAction)doneButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LB_DID_SET_CHART_NOTIF object:@{@"barCount" : @(_chartView.barCount),@"theme" : _chartView.theme, @"dataSource" : _chartView.dataSource}];
    [self removeFromSuperview];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)themeButtonClicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        _chartView.theme = [CPTTheme themeNamed:kCPTLBPresentTheme];
    } else {
        _chartView.theme = [CPTTheme themeNamed:kCPTLBSimpleTheme];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual:@"\n"]) {
        
        int barCount = [textField.text intValue];
        
        if (barCount > 0 ) {
            _chartView.barCount = barCount;
        }
        [textField resignFirstResponder];
        
    } else if ([string isEqual:@""]) {
        return TRUE;
        
    } else {
        if (string.intValue <= 0 || string.intValue > 5) {
            return FALSE;
        }
        
    }
    
    return TRUE;
}

@end
