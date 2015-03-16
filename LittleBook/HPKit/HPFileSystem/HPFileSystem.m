//
//  HPFileSystem.m
//  GTalkIM
//
//  Created by hupeng on 14-6-5.
//
//

#import "HPFileSystem.h"

@implementation HPFileSystem

- (id)init
{
    self = [super init];
    if (self) {        
        [self buildFileTree];
    }
    return self;
}

#pragma mark -- private methods

- (NSString *)getFullDirectoryPath
{
    NSString *filePath = NSSearchPathForDirectoriesInDomains([self rootDirectory], NSUserDomainMask, TRUE)[0];
    
    if ([self directory]) {
        
        filePath = [filePath stringByAppendingPathComponent:[self directory]];
    }
    return filePath;
}

- (void)buildFileTree
{
    [[NSFileManager defaultManager] createDirectoryAtPath:[self getFullDirectoryPath] withIntermediateDirectories:true attributes:nil error:nil];
}

#pragma mark - common methods

- (NSString *)fullPathForName:(NSString *)fileName
{
    NSString *directory = [self getFullDirectoryPath];
    
    if (!fileName) {
        return directory;
    }
    
    return [directory stringByAppendingPathComponent:fileName];
}


- (NSString *)searchFile:(NSString *)fileName
{
    NSString *filePath = [self fullPathForName:fileName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:FALSE] ? filePath : nil;
}

- (NSString *)saveFile:(NSData *)data withFileName:(NSString *)fileName
{
    NSString *filePath = [self fullPathForName:fileName];
    [data writeToFile:filePath atomically:true];
    return filePath;
}

- (id)getFileSize:(NSString *)filePath
{
    NSDictionary *fileAttrs = [[NSFileManager defaultManager]  attributesOfItemAtPath:filePath error:nil];
    
    return [fileAttrs objectForKey:NSFileSize];
}

#pragma mark - methods to be implemented

- (NSString *)directory
{
    return nil;
}

- (NSSearchPathDirectory)rootDirectory
{
    return NSDocumentDirectory;
}

#pragma mark - static methods

+ (NSString *)documentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE)[0];
}

+ (NSString *)cachePath
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE)[0];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)filePath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return FALSE;
    }
    
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    return success;
}
@end
