//
//  UITextView+TextViewExt.m
//  LittleBook
//
//  Created by 胡鹏 on 15/4/26.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "UITextView+TextViewExt.h"
#import "NSLayoutManager+LayoutManagerExt.h"

@implementation UITextView (TextViewExt)

- (NSInteger)numberOfLines
{
    __block NSInteger _lineIndex = 0;
    [self.layoutManager enumerateLinesForGlyphRange:NSMakeRange(0, self.text.length) usingBlock:^(NSInteger lineIndex, NSRange lineRange, BOOL *stop) {
        _lineIndex = lineIndex;
    }];
    return _lineIndex + 1;
}

- (NSInteger)lineIndexOfCurrentCursour
{
    return [self lineIndexOfPoint:self.selectedRange.location];
}

- (NSInteger)lineIndexOfPoint:(NSInteger)point
{
    __block NSInteger _lineIndex = 0;
    
    [self.layoutManager enumerateLinesForGlyphRange:NSMakeRange(0, self.text.length) usingBlock:^(NSInteger lineIndex, NSRange lineRange, BOOL *stop) {
        if (point <= lineRange.location + lineRange.length) {
            _lineIndex = lineIndex;
            *stop = TRUE;
        }
    }];
    
    return _lineIndex;
}

- (NSRange)rangeOfLineAtIndex:(NSInteger)lineIndex
{
    __block NSRange   _lineRange = NSMakeRange(0, 0);
    __block NSInteger _lineIndex = lineIndex;
    
    [self.layoutManager enumerateLinesForGlyphRange:NSMakeRange(0, self.text.length) usingBlock:^(NSInteger lineIndex, NSRange lineRange, BOOL *stop) {
        if (_lineIndex == lineIndex) {
            _lineRange = lineRange;
            *stop = TRUE;
        }
    }];
    
    return _lineRange;
}

- (void)insertSeperatorLineAtPoint:(NSInteger)point
{
    NSString *text = self.text;
    NSString *seperatorLine = @"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    
    NSString *preStr = [text substringToIndex:point];
    NSString *sufStr = [text substringFromIndex:point];

    NSString *testStr = [NSString stringWithFormat:@"%@\n%@%@", preStr, seperatorLine, sufStr];
    
    NSInteger lineIndex = [self lineIndexOfCurrentCursour];

    self.text = testStr;
    
    NSRange rang = [self rangeOfLineAtIndex:lineIndex + 1];
    
    NSString *finalStr = [NSString stringWithFormat:@"%@\n%@%@", preStr, [seperatorLine substringToIndex:rang.length], sufStr];
    self.text = finalStr;
}

- (void)insertFakeEnterAtPosition:(NSInteger)position
{
    NSString *text = self.text;
    
    NSString *preStr = [text substringToIndex:position];
    NSString *sufStr = [text substringFromIndex:position];
    
    NSInteger lineIndex = [self lineIndexOfCurrentCursour];
    NSRange range = [self rangeOfLineAtIndex:lineIndex];

    NSString *emptyStr = @"";
    for (int i = 0; i < range.length - position; i++) {
        emptyStr = [emptyStr stringByAppendingString:@" "];
    }
    
    NSString *finalStr = [NSString stringWithFormat:@"%@%@%@", preStr, emptyStr, sufStr];
    self.text = finalStr;

}

- (NSInteger)cursourLocation
{
    return self.selectedRange.location;
}

- (void)moveCursor:(NSInteger)distance
{
    NSInteger cursorLocation = self.selectedRange.location;
    
    NSUInteger targetLocation = cursorLocation + distance;
    
    targetLocation = MAX(targetLocation, 0);
    targetLocation = MIN(targetLocation, self.text.length);
    
    self.selectedRange = NSMakeRange(targetLocation, 0);
}

- (void)moveCursorToPreviousLine
{
    if ([self numberOfLines] <= 1) {
        self.selectedRange = NSMakeRange(0, 0);
        return;
    }
    
    NSInteger cursorLocation = self.selectedRange.location;
    NSInteger selectedLineIndex = [self lineIndexOfCurrentCursour];
    NSRange selectedLineRange = [self rangeOfLineAtIndex:selectedLineIndex];
    NSRange previousLineRange = [self rangeOfLineAtIndex:selectedLineIndex - 1];
    
    NSInteger offset = cursorLocation - selectedLineRange.location;
    
    offset = MIN(offset, previousLineRange.length);
    
    self.selectedRange = NSMakeRange(previousLineRange.location + offset, 0);
}

-(float)maxContentSizeY
{
    float oY = 0;
    if(self.text && self.text.length > 0) {
        oY = ceilf([self sizeThatFits:self.frame.size].height) + self.font.pointSize;
//        oY = self.contentSize.height + self.contentInset.top +self.contentInset.bottom;
    }
    return oY;
}
@end
