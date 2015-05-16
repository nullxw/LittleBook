//
//  LBExportTemp.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/2.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBExportTemp.h"
#import "LBAppendixFileManager.h"
#import "LBPanelStyleManager.h"
#import "LBAppendixManager.h"
#import "FSVoiceBubble.h"
#import "LBAppContext.h"
#import "Document.h"

@interface LBExportTemp ()
{
    NSMutableArray *_appendixs;
    NSMutableArray *_appendixViews;
    NSMutableArray *_appendixPaths;
}
@property (nonatomic, weak) IBOutlet UITextField *titleField;
@property (nonatomic, weak) IBOutlet UITextView *contentField;

@end

@implementation LBExportTemp

- (void)setDocument:(Document *)document
{
    _document = document;
    [self setupInterface];
}

- (void)setupInterface
{
    [self updateInterfaceWithSettings];
    [self updateInterfaceWithDocument];

    float maxY = _contentField.contentSize.height;
    for (UIView *view in _appendixViews) {
        maxY = MAX(maxY, CGRectGetMaxY(view.frame));
    }
    
    float dH = maxY - CGRectGetHeight(_contentField.frame);
    CGRect frame = self.frame;
    frame.size.height = frame.size.height + dH;
    self.frame = frame;
}

- (void)updateInterfaceWithSettings
{
    NSDictionary *settings = [LBAppContext context].settings;
    
    int fontSize = [settings[kLBFontSizeSetting] intValue];
    PanelStyle *currentStyle = [[LBPanelStyleManager defaultManager] currentStyle];
    
    self.backgroundColor = currentStyle.panelColor;
    _contentField.textColor = currentStyle.fontColor;
    _titleField.textColor   = currentStyle.fontColor;
    
    _contentField.font = [UIFont fontWithName:_contentField.font.fontName size:fontSize];
    _titleField.font = [UIFont fontWithName:_titleField.font.fontName size:fontSize + 2];
}

- (void)updateInterfaceWithDocument
{
    _titleField.text = _document.title;
    _contentField.text = _document.content;
    
    NSArray *appendixs = [LBAppendixManager appendixs:_document.documentID];
    
    _appendixs = [[NSMutableArray alloc] initWithCapacity:0];
    _appendixViews = [[NSMutableArray alloc] initWithCapacity:0];
    _appendixPaths = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (appendixs) {
        [_appendixs addObjectsFromArray:appendixs];
    }
    for (Appendix *appendix in appendixs) {
        [self creatAppendixViewWithAppendix:appendix];
    }
    
    _contentField.textContainer.exclusionPaths = _appendixPaths;
}
- (void)creatAppendixViewWithAppendix:(Appendix *)appendix
{
    NSString *appendixPath = [[LBAppendixFileManager defaultManager] pathForAppendix:appendix.appendixID];
    
    CGRect frame = CGRectZero;
    
    if ([appendix.type integerValue] == LBAppendixTypeAudio) {
        
        if (!appendix.frame) {
            frame = CGRectMake(0, [self getMaxYOfTextView], 110, 30);
            appendix.frame = NSStringFromCGRect(frame);
        } else {
            frame = CGRectFromString(appendix.frame);
        }
        
        FSVoiceBubble *voiceBubble = [[FSVoiceBubble alloc] initWithFrame:frame];
        voiceBubble.duration = [appendix.duration intValue];
        voiceBubble.durationInsideBubble = YES;
        voiceBubble.contentURL = [NSURL fileURLWithPath:appendixPath];
        
        [_appendixViews addObject:voiceBubble];
        [_appendixPaths addObject:[self exclusionPathForFrame:frame]];
        [_contentField addSubview:voiceBubble];
        
    } else {
        
        CGRect frame = CGRectFromString(appendix.frame);
        
        UIImageView *appendixView = [[UIImageView alloc] initWithFrame:frame];
        appendixView.image = [UIImage imageWithContentsOfFile:appendixPath];

        [_appendixViews addObject:appendixView];
        [_appendixPaths addObject:[self exclusionPathForFrame:frame]];
        [_contentField addSubview:appendixView];
    }
}

- (UIBezierPath *)exclusionPathForFrame:(CGRect)frame
{
    float offset = _contentField.font.pointSize * 0.5;
    
    return [UIBezierPath bezierPathWithRect:CGRectMake(frame.origin.x - offset, frame.origin.y - offset, frame.size.width + 2 * offset, frame.size.height)];
}


- (float)getMaxYOfTextView
{
    float oY = [_contentField maxContentSizeY];
    
    for (UIView *appendixView in _appendixViews) {
        oY = MAX(oY, CGRectGetMaxY(appendixView.frame));
    }
    return oY + 5;
}
@end
