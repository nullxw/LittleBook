//
//  PanelSettingManager.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/9.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanelStyle : NSObject

@property (nonatomic, strong) UIColor  *panelColor;
@property (nonatomic, strong) NSString *panelDesc;
@property (nonatomic, strong) UIFont   *font;
@property (nonatomic, strong) UIColor  *fontColor;
@property (nonatomic, strong) NSString *styleName;
@end

@interface LBPanelStyleManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic, strong) NSArray *panelStyles;

- (PanelStyle *)currentStyle;

@end
