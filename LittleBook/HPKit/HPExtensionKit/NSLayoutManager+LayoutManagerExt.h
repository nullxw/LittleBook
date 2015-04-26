//
//  NSLayoutManager+LayoutManagerExt.h
//  LittleBook
//
//  Created by 胡鹏 on 15/4/26.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutManager (LayoutManagerExt)

// 修正有 有exclusive path 情况
- (void)enumerateLinesForGlyphRange:(NSRange)lineRange usingBlock:(void (^)(NSInteger lineIndex, NSRange lineRange, BOOL *_stop))block;


@end
