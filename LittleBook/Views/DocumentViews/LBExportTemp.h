//
//  LBExportTemp.h
//  LittleBook
//
//  Created by 胡鹏 on 15/5/2.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPRoundCornerView.h"

@class Document;

@interface LBExportTemp : HPRoundCornerView

+ (instancetype)tempForPDF:(Document *)document;
+ (instancetype)tempForImage:(Document *)document;
+ (instancetype)tempForText:(Document *)document;
@end
