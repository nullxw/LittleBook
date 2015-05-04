//
//  HPDownFrequenceMachine.h
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/27.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPDownFrequenceMachine : NSObject

- (void)handleEvent;

- (void)registerEventHandleBlock:(void(^)())block;

@end
