//
//  LBCustomSettingCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBCustomSettingCell.h"
#import "LBAppContext.h"

@interface LBCustomSettingCell ()
{
    NSArray *_fonts;
}

@property (nonatomic, weak) IBOutlet UISlider *fontSizeSlider;
@property (nonatomic, weak) IBOutlet UISwitch *dragSetting;
@property (nonatomic, weak) IBOutlet UISwitch *resizeSetting;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *fontButtons;

@end

@implementation LBCustomSettingCell

- (void)awakeFromNib
{
    
    _fonts = @[@"Helvetica-Neue", @"Courier", @"Georgia"];
    
    NSDictionary *settings = [LBAppContext context].settings;
    _fontSizeSlider.value = [settings[kLBFontSizeSetting] integerValue];
    _dragSetting.on = [settings[kLBDragSetting] boolValue];
    _resizeSetting.on = [settings[kLBResizeSetting] boolValue];
    
    NSString *fontName = settings[kLBFontNameSetting];
    UIButton *fontButton = _fontButtons[[_fonts indexOfObject:fontName]];
    fontButton.selected = TRUE;
}

- (IBAction)fontButtonClicked:(UIButton *)sender
{
    for (UIButton *fontButton in _fontButtons) {
        fontButton.selected = FALSE;
    }
    
    sender.selected = TRUE;
    
    NSInteger fontIndex = sender.tag;
    NSString *fontName = _fonts[fontIndex];
    
    NSMutableDictionary *settings = [LBAppContext context].settings;
    settings[kLBFontNameSetting] = fontName;
    [[LBAppContext context] updateSettings];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    int fontSize = sender.value;
    
    NSMutableDictionary *settings = [LBAppContext context].settings;
    settings[kLBFontSizeSetting] = @(fontSize);
    
    [[LBAppContext context] updateSettings];
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    BOOL onValue = sender.on;
    
    NSMutableDictionary *settings = [LBAppContext context].settings;
    
    if ([sender isEqual:_dragSetting]) {
        settings[kLBDragSetting] = @(onValue);
    } else {
        settings[kLBResizeSetting] = @(onValue);
    }
    [[LBAppContext context] updateSettings];

}
@end
