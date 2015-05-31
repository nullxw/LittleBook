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
    NSMutableArray *_appendixPaths;
    
    float _maxY;
}
@property (nonatomic, weak) IBOutlet UITextField *titleField;
@property (nonatomic, weak) IBOutlet UITextView *contentField;

@end

@implementation LBExportTemp

- (void)awakeFromNib
{
    _contentField.editable   =TRUE;
    _contentField.selectable = FALSE;
}

- (void)setDocument:(Document *)document
{
    _document = document;
    [self updateInterfaceWithSettings];
    [self updateInterfaceWithDocument];
    
    _maxY = MAX(_contentField.maxContentSizeY, _maxY);
    
    float dH = _maxY - CGRectGetHeight(_contentField.frame);
    
    CGRect toFrame = self.frame;
    toFrame.size.height += dH;
    
    self.frame = toFrame;
}

- (void)updateInterfaceWithSettings
{
    NSDictionary *settings = [LBAppContext context].settings;
    
    int fontSize = [settings[kLBFontSizeSetting] intValue];
    PanelStyle *currentStyle = [[LBPanelStyleManager defaultManager] currentStyle];
    
    self.backgroundColor = currentStyle.panelColor;
    _contentField.textColor = currentStyle.fontColor;
    _titleField.textColor   = currentStyle.fontColor;
    
//    _contentField.font = [UIFont fontWithName:_contentField.font.fontName size:fontSize];
    _titleField.font = [UIFont fontWithName:_titleField.font.fontName size:fontSize + 2];
}

- (void)updateInterfaceWithDocument
{
    _titleField.text = _document.title;
//    _contentField.text = _document.content;
    
    NSDictionary *settings = [LBAppContext context].settings;
    
    int fontSize = [settings[kLBFontSizeSetting] intValue];
    //
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_document.content];
    NSRange rang = NSMakeRange(0, _document.content.length);
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:_contentField.font.fontName size:fontSize] range:rang];
    
    _contentField.attributedText = attrStr;
    
    NSArray *appendixs = [LBAppendixManager appendixs:_document.documentID];

    _appendixPaths = [[NSMutableArray alloc] initWithCapacity:appendixs.count];
    for (Appendix *appendix in appendixs) {
        [self creatAppendixViewWithAppendix:appendix];
    }
    
    _contentField.textContainer.exclusionPaths = _appendixPaths;
 }

- (void)creatAppendixViewWithAppendix:(Appendix *)appendix
{
    NSString *appendixPath = [[LBAppendixFileManager defaultManager] pathForAppendix:appendix.appendixID];
    
    CGRect frame = CGRectFromString(appendix.frame);
    
    _maxY = CGRectGetMaxY(frame);
    
    if ([appendix.type integerValue] == LBAppendixTypeAudio) {
        
        FSVoiceBubble *voiceBubble = [[FSVoiceBubble alloc] initWithFrame:frame];
        voiceBubble.duration = [appendix.duration intValue];
        voiceBubble.durationInsideBubble = YES;
        voiceBubble.contentURL = [NSURL fileURLWithPath:appendixPath];

        [_appendixPaths addObject:[self exclusionPathForFrame:frame]];
        [_contentField addSubview:voiceBubble];
        
    } else {
        
        UIImageView *appendixView = [[UIImageView alloc] initWithFrame:frame];
        appendixView.image = [UIImage imageWithContentsOfFile:appendixPath];

        [_appendixPaths addObject:[self exclusionPathForFrame:frame]];
        [_contentField addSubview:appendixView];
    }
}

- (UIBezierPath *)exclusionPathForFrame:(CGRect)frame
{
    float offset = _contentField.font.pointSize * 0.5;
    
    return [UIBezierPath bezierPathWithRect:CGRectMake(frame.origin.x - offset, frame.origin.y - offset, frame.size.width + 2 * offset, frame.size.height)];
}
@end
