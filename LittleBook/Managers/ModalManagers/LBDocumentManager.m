//
//  LBDocumentManager.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/16.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentManager.h"

@implementation LBDocumentManager

+ (LBDocumentManager *)defaultManager
{
    CREATE_SINGLETON_INSTANCE([[LBDocumentManager alloc] init]);
}

@end
