//
//  LBDocumentListCell.h
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPEditCell.h"

@class Document;
@interface LBDocumentListCell : HPEditCell

@property (nonatomic, strong) Document *document;
@end