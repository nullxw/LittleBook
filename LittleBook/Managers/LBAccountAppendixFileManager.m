//
//  LBAccountAppendixFileManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//
#define ACCOUNT_APPENDIX_NAME(APPENDIXID) [NSString stringWithFormat:@"APPENDIX_%@", APPENDIXID]

#define ACCOUNT_APPENDIX_THUMBNAIL_NAME(APPENDIXID) [NSString stringWithFormat:@"APPENDIX_THUMBNAIL_%@", APPENDIXID]

#import "LBAccountAppendixFileManager.h"

@implementation LBAccountAppendixFileManager

+ (LBAccountAppendixFileManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBAccountAppendixFileManager alloc] init]);
}

- (NSString *)directory
{
    return @"AccountAppendix";
}

- (NSSearchPathDirectory)rootDirectory
{
    return NSDocumentDirectory;
}

- (void)saveAppendix:(NSData *)appendixData forAppendixID:(NSNumber *)appendxID
{
    [appendixData writeToFile:[self pathForAppendix:appendxID] atomically:YES];
}

- (NSString *)pathForAppendix:(NSNumber *)appendxID
{
    return [self fullPathForName:ACCOUNT_APPENDIX_NAME(appendxID)];
}

- (NSString *)pathForAppendixThumbnail:(NSNumber *)appendxID
{
    NSString *path = [self fullPathForName:ACCOUNT_APPENDIX_THUMBNAIL_NAME(appendxID)];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        CGSize defaultSize = CGSizeMake(40, 40);
        
        UIImage *image = [UIImage imageWithContentsOfFile:[self pathForAppendix:appendxID]];
        UIImage *thumbnail = [image scaleToSize:defaultSize];
        [UIImageJPEGRepresentation(thumbnail, 1.0) writeToFile:path atomically:YES];
    }
    return path;
}

@end
