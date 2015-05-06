//
//  LBAppendixFileManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/18.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#define LB_APPENDIX_NAME(APPENDIXID) [NSString stringWithFormat:@"APPENDIX_%@", APPENDIXID]

#define LB_APPENDIX_THUMBNAIL_NAME(APPENDIXID) [NSString stringWithFormat:@"APPENDIX_THUMBNAIL_%@", APPENDIXID]

#import "LBAppendixFileManager.h"

@implementation LBAppendixFileManager

+ (LBAppendixFileManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBAppendixFileManager alloc] init]);
}

- (NSString *)directory
{
    return @"Appendixs";
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
    return [self fullPathForName:LB_APPENDIX_NAME(appendxID)];
}

- (NSString *)pathForAppendixThumbnail:(NSNumber *)appendxID
{
    NSString *path = [self fullPathForName:LB_APPENDIX_THUMBNAIL_NAME(appendxID)];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        CGSize defaultSize = CGSizeMake(40, 40);
        
        UIImage *image = [UIImage imageWithContentsOfFile:[self pathForAppendix:appendxID]];
        UIImage *thumbnail = [image scaleToSize:defaultSize];
        [UIImageJPEGRepresentation(thumbnail, 1.0) writeToFile:path atomically:YES];
    }
    return path;
}

- (void)removeFilesForAppendix:(NSNumber *)appendxID
{
    NSString *filePath = [self pathForAppendix:appendxID];
    NSString *thumbnailPath = [self pathForAppendixThumbnail:appendxID];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:thumbnailPath error:nil];
}

@end
