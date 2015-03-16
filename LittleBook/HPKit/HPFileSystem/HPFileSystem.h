//
//  HPFileSystem.h
//  GTalkIM
//
//  Created by hupeng on 14-6-5.
//
//

typedef NS_ENUM(NSInteger, ILSMediaType) {
    ILSMediaTypeImage = 0,
    ILSMediaTypeVideo = 1,
    ILSMediaTypeBoth = 2, // 此参数 无实际意义，只在 storymanager中 有用到
    ILSMediaTypeText =3
};

#import <Foundation/Foundation.h>

@interface HPFileSystem : NSObject

#pragma mark - methods to be implemented

- (NSString *)directory;

- (NSSearchPathDirectory)rootDirectory;

#pragma mark - common methods

- (NSString *)fullPathForName:(NSString *)fileName;

- (NSString *)searchFile:(NSString *)fileName;

- (NSString *)saveFile:(NSData *)data withFileName:(NSString *)fileName;

// return bytes
- (id)getFileSize:(NSString *)filePath;

#pragma mark - static methods

+ (NSString *)documentPath;

+ (NSString *)cachePath;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)filePath;

@end
