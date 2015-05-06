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
    _createTimeLabel.textColor = [UIColor colorWithR:47 g:138 b:193 a:1.0];
    _titleLabel.textColor = [UIColor colorWithR:47 g:138 b:193 a:1.0];
}

- (void)setDocument:(Document *)document
{
    _document = document;
    
    _createTimeLabel.text = [_document.createTime formattedString:@"yyyy | MM | dd"];
    _titleLabel.text      = document.title;
    _contentLabel.text    = document.content;
    
    if (document.favourite.boolValue) {
        _createTimeLabel.textColor = [UIColor colorWithR:237 g:115 b:118 a:1.0];
        _titleLabel.textColor = [UIColor colorWithR:237 g:115 b:118 a:1.0];
    }
    
    
    
    Appendix *appendix = [LBAppendixManager appendixs:document.documentID].firstObject;
    
    if (appendix) {
        NSString *filePath = [[LBAppendixFileManager defaultManager] pathForAppendixThumbnail:appendix.appendixID];
        _appendixView.image = [UIImage imageWithContentsOfFile:filePath];
    }
}

@end