//
//  NSLayoutManager+LayoutManagerExt.m
//  LittleBook
//
//  Created by 胡鹏 on 15/4/26.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "NSLayoutManager+LayoutManagerExt.h"

@implementation NSLayoutManager (LayoutManagerExt)

- (void)enumerateLinesForGlyphRange:(NSRange)lineRange usingBlock:(void (^)(NSInteger lineIndex, NSRange lineRange, BOOL *_stop))block
{
    __block CGRect  previousRect = CGRectZero;
    __block NSRange lineGlyphRange = NSMakeRange(0, 0);
    __block NSInteger lineIndex = 0;
    
    __block BOOL shouldStop = FALSE;
    
    [self enumerateLineFragmentsForGlyphRange:lineRange usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
          
        if (shouldStop) {
            *stop = TRUE;
            return;
        }
        if (fabs(rect.origin.y - previousRect.origin.y) < 1) {
            // same line
            lineGlyphRange = NSMakeRange(lineGlyphRange.location, lineGlyphRange.length + glyphRange.length);
            
            if (lineRange.location + lineRange.length == glyphRange.location + glyphRange.length) {
                // last line
                block (lineIndex++, lineGlyphRange, &shouldStop);
            }
            
        } else {
            // prepare for new Line
            block (lineIndex++, lineGlyphRange, &shouldStop);
            previousRect = rect;
            lineGlyphRange = glyphRange;
            
            if (shouldStop) {
                *stop = TRUE;
                return;
            }
            
            
            if (lineRange.location + lineRange.length == glyphRange.location + glyphRange.length) {
                // last line
                block (lineIndex++, lineGlyphRange, &shouldStop);
            }
            
        }
    }];
}
@end
