//
//  UITextView+TextViewExt.h
//  LittleBook
//
//  Created by 胡鹏 on 15/4/26.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TextViewExt)

- (NSInteger)numberOfLines;
- (NSInteger)lineIndexOfCurrentCursour;
- (NSInteger)lineIndexOfPoint:(NSInteger)point;
- (NSRange)rangeOfLineAtIndex:(NSInteger)lineIndex;
- (void)insertSeperatorLineAtPoint:(NSInteger)point;

- (void)insertFakeEnterAtPosition:(NSInteger)position;

- (NSInteger)cursourLocation;
- (void)moveCursor:(NSInteger)distance;
- (void)moveCursorToPreviousLine;

-(float)maxContentSizeY;

@end
