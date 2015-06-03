//
//  StringKit.h
//  snapgrab
//
//  Created by hupeng on 14-10-24.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (StringExt)

- (BOOL)isEmpty;



- (NSDate *)dateFromPattern:(NSString *)pattern;

- (NSString *)truncateNewLine;

@end

@interface NSString  (Encrypt)

- (NSString*)MD5;

- (NSString*)SHA1;

- (NSString*)SHA256;

@end
