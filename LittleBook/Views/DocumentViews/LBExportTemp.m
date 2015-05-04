//
//  LBExportTemp.m
//  LittleBook
//
//  Created by 胡鹏 on 15/5/2.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBExportTemp.h"

@interface LBExportTemp ()
{

}
@property (nonatomic, weak) IBOutlet UITextField *titileField;
@property (nonatomic, weak) IBOutlet UITextView *contentField;

@end

@implementation LBExportTemp

+ (instancetype)tempForPDF:(Document *)document
{
    return [LBExportTemp loadNibForCurrentDevice];
}
+ (instancetype)tempForImage:(Document *)document
{
    return [LBExportTemp loadNibForCurrentDevice];
}
+ (instancetype)tempForText:(Document *)document
{
    return [LBExportTemp loadNibForCurrentDevice];
}

- (void)prepareTempWithDocument:(Document *)document
{

}

@end
