//
//  PanelSettingManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/9.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBPanelStyleManager.h"
#import "LBAppContext.h"

@implementation PanelStyle

@end

@implementation LBPanelStyleManager

+ (instancetype)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBPanelStyleManager alloc] init]);
}

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString *settingInfoPath = [[NSBundle mainBundle] pathForResource:@"PanelStyleInfos" ofType:@"plist"];

        NSArray *panelInfos = [NSArray arrayWithContentsOfFile:settingInfoPath];
        
        NSMutableArray *panelStyles = [[NSMutableArray alloc] initWithCapacity:panelInfos.count];
        
        for (NSDictionary *panelInfo in panelInfos) {
            PanelStyle *panelStyle = [[PanelStyle alloc] init];
            NSDictionary *panelColorInfo = panelInfo[@"panelColor"];
            NSDictionary *fontColorInfo  = panelInfo[@"fontColor"];
            
            panelStyle.styleName = panelInfo[@"styleName"];
            panelStyle.panelDesc = panelInfo[@"description"];
            panelStyle.panelColor= [UIColor colorWithR:[panelColorInfo[@"r"] floatValue]
                                                     g:[panelColorInfo[@"g"] floatValue]
                                                     b:[panelColorInfo[@"b"] floatValue]
                                                     a:[panelColorInfo[@"a"] floatValue]];
            panelStyle.fontColor = [UIColor colorWithR:[fontColorInfo[@"r"] floatValue]
                                                     g:[fontColorInfo[@"g"] floatValue]
                                                     b:[fontColorInfo[@"b"] floatValue]
                                                     a:[fontColorInfo[@"a"] floatValue]];
            panelStyle.font      = [UIFont fontWithName:panelInfo[@"fontName"]
                                                   size:[panelInfo[@"fontSize"] floatValue]];
            
            [panelStyles addObject:panelStyle];
        }
        
        self.panelStyles = panelStyles;
    }
    return self;
}

- (PanelStyle *)currentStyle
{
    NSString *selectedStyleName = [LBAppContext context].settings[kLBPanelStyleSetting];

    for (int i = 0; i < _panelStyles.count; i++) {
        PanelStyle *panelStyle = _panelStyles[i];
        if ([panelStyle.styleName isEqualToString:selectedStyleName]) {
            return panelStyle;
        }
    }
    return nil;
}

@end
