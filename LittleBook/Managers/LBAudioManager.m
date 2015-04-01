//
//  LBAudioManager.m
//  LittleBook
//
//  Created by hupeng on 15/4/1.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBAudioManager.h"
#import <AudioToolbox/AudioToolbox.h>  

@implementation LBAudioManager

static void SoundFinished(SystemSoundID soundID,void* sample)
{
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(sample);
    CFRelease(sample);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)playSystemSound:(NSString *)filePath
{
    SystemSoundID soundID;
    
    NSURL* sample = [[NSURL alloc] initWithString:filePath];
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(sample), &soundID);
    if (err) {
        NSLog(@"Error occurred assigning system sound!");
        return;
    }
    /*添加音频结束时的回调*/
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, SoundFinished,(__bridge void *)(sample));
    /*开始播放*/
    AudioServicesPlaySystemSound(soundID);
    CFRunLoopRun();
}

@end
