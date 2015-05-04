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

- (void)setDocument:(Document *)document
{
    _document = document;
    
    _createTimeLabel.text = [_document.createTime formattedString:@"yyyy | MM | dd"];
    _titleLabel.text = document.title;
    _contentLabel.text = document.content;
    
    Appendix *appendix = [LBAppendixManager appendixs:document.documentID].lastObject;
    
    if (appendix) {
        NSString *filePath = [[LBAppendixFileManager defaultManager] pathForAppendixThumbnail:appendix.appendixID];
        _appendixView.image = [UIImage imageWithContentsOfFile:filePath];
    }
}

@end