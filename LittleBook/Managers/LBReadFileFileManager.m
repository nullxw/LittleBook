//
//  LBReadFileFileManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//
#define LB_READFILE_NAME(FILEID) [NSString stringWithFormat:@"READFILE_%@.pdf", FILEID]
#define LB_READFILE_IMAGE_NAME(FILEID) [NSString stringWithFormat:@"READFILE_IMAGE_%@.jpg", FILEID]

#define LB_READFILE_THUMBNAIL_NAME(FILEID) [NSString stringWithFormat:@"READFILE_THUMBNAIL_%@.jpg", FILEID]

#import "LBReadFileFileManager.h"
#import "UIImage+PDF.h"

@implementation LBReadFileFileManager

+ (LBReadFileFileManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBReadFileFileManager alloc] init]);
}

- (NSString *)directory
{
    return @"ReadFiles";
}

- (NSSearchPathDirectory)rootDirectory
{
    return NSLibraryDirectory;
}

- (void)saveReadFileImage:(NSNumber *)fileID withData:(NSData *)data;
{
    [data writeToFile:[self pathForReadFileImage:fileID] atomically:YES];
}

- (NSString *)pathForReadFile:(NSNumber *)fileID
{
    return [self fullPathForName:LB_READFILE_NAME(fileID)];
}

- (NSString *)pathForReadFileImage:(NSNumber *)fileID
{
    NSString *imagePath = [self fullPathForName:LB_READFILE_IMAGE_NAME(fileID)];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil]) {
        NSString *pdfPath = [self pathForReadFile:fileID];
        UIImage *image = [UIImage imageOrPDFWithContentsOfFile:pdfPath];
        
        [UIImageJPEGRepresentation(image, 0.6) writeToFile:imagePath atomically:YES];
    }
    
    return imagePath;
}

- (NSString *)pathForThumbnail:(NSNumber *)fileID
{
    NSString *path = [self fullPathForName:LB_READFILE_THUMBNAIL_NAME(fileID)];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        CGSize defaultSize = CGSizeMake(40, 40);
        
        UIImage *image = [UIImage imageWithContentsOfFile:[self pathForReadFile:fileID]];
        UIImage *thumbnail = [image scaleToSize:defaultSize];
        [UIImageJPEGRepresentation(thumbnail, 1.0) writeToFile:path atomically:YES];
    }
    return path;
}

- (void)removeReadFile:(NSNumber *)fileID
{
    NSString *filePath = [self pathForReadFile:fileID];
    NSString *thumbnailPath = [self pathForThumbnail:fileID];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:thumbnailPath error:nil];
}


@end
