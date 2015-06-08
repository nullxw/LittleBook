//
//  LBDocumentListCell.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentListCell.h"
#import "LBAppendixFileManager.h"
#import "LBAppendixManager.h"
#import "Document.h"
#import "ReadFile.h"

@interface LBDocumentListCell ()

@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appendixView;

@end

@implementation LBDocumentListCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    _appendixView.image = nil;
    _createTimeLabel.textColor = [UIColor colorWithR:47 g:138 b:193 a:1.0];
    _titleLabel.textColor = [UIColor colorWithR:47 g:138 b:193 a:1.0];
}

- (void)setDocument:(Document *)document
{
    _document = document;
    
    _createTimeLabel.text = [_document.createTime formattedString:@"yyyy | MM | dd"];
    _titleLabel.text      = document.title;
    _contentLabel.text    = [document.content truncateNewLine];
    
    if (document.favourite.boolValue) {
        _createTimeLabel.textColor = [UIColor colorWithR:237 g:115 b:118 a:1.0];
        _titleLabel.textColor = [UIColor colorWithR:237 g:115 b:118 a:1.0];
    }
    
    Appendix *thumbnailAppendix = [LBAppendixManager thumbnailAppendixOf:document.documentID];
    
    if (thumbnailAppendix) {
        NSString *filePath = [[LBAppendixFileManager defaultManager] pathForAppendixThumbnail:thumbnailAppendix.appendixID];
        _appendixView.image = [UIImage imageWithContentsOfFile:filePath];
    }
}

- (void)setReadFile:(ReadFile *)readFile
{
    _readFile = readFile;
    
    _createTimeLabel.text = [_readFile.createTime formattedString:@"yyyy | MM | dd"];
    _titleLabel.text      = _readFile.title;
    _contentLabel.text    = [_readFile.content truncateNewLine];
    
    if (_readFile.favourite.boolValue) {
        _createTimeLabel.textColor = [UIColor colorWithR:237 g:115 b:118 a:1.0];
        _titleLabel.textColor = [UIColor colorWithR:237 g:115 b:118 a:1.0];
    }
    
    if (_readFile.thumbnailID) {
        NSString *filePath = [[LBAppendixFileManager defaultManager] pathForAppendixThumbnail:_readFile.thumbnailID];
        _appendixView.image = [UIImage imageWithContentsOfFile:filePath];
    }
}

@end