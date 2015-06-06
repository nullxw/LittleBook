//
//  LCVoice.m
//  LCVoiceHud
//
//  Created by 郭历成 on 13-6-21.
//  Contact titm@tom.com
//  Copyright (c) 2013年 Wuxiantai Developer Team.(http://www.wuxiantai.com) All rights reserved.
//

#import "LCVoice.h"
#import "LCVoiceHud.h"
#import <AVFoundation/AVFoundation.h>
#import "HPFileSystem.h"

#pragma mark - <DEFINES>

#define WAVE_UPDATE_FREQUENCY   0.05

#pragma mark - <CLASS> LCVoice

@interface LCVoice () <AVAudioRecorderDelegate>
{
    NSTimer * timer_;
    
    LCVoiceHud * voiceHud_;    
}

@property(nonatomic,strong) AVAudioRecorder * recorder;

@end

@implementation LCVoice

#pragma mark - Publick Function

-(void)startRecordWithPath:(NSString *)path
{    
    NSError * err = nil;
    
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryRecord error:&err];
    
	if(err){
        return;
	}
    
	[audioSession setActive:YES error:&err];
    
	err = nil;
	if(err){
        return;
	}
	
    if (!path) {
        self.recordPath = [[HPFileSystem documentPath] stringByAppendingPathComponent:@"temp.caf"];
    } else {
        self.recordPath = path;
    }
    
	NSMutableDictionary * recordSettings = [NSMutableDictionary dictionary];
    
    [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [recordSettings setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
    [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    

    NSURL* outURL = [NSURL fileURLWithPath:_recordPath];
    [[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
    
    self.recorder = [[ AVAudioRecorder alloc] initWithURL:outURL settings:recordSettings error:&err];
    
    if (err) {
        return;
    }
    
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
    if ([self.recorder prepareToRecord] == YES){
        [self.recorder record];

    }
    self.recordTime = 0;
    [self resetTimer];
    
    timer_ = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    
    [self showVoiceHudOrHide:YES];
}

-(void) stopRecordWithCompletionBlock:(void (^)())completion
{    
    dispatch_async(dispatch_get_main_queue(),completion);
    [self resetTimer];
    [self showVoiceHudOrHide:NO];
}

#pragma mark - Timer Update

- (void)updateMeters {
    
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    
    if (voiceHud_)
    {
        /*  发送updateMeters消息来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        
        if (_recorder) {
            [_recorder updateMeters];
        }
    
        float peakPower = [_recorder averagePowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    
        [voiceHud_ setProgress:peakPowerForChannel];
    }
}

#pragma mark - Helper Function

-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
    
    if (voiceHud_) {
        [voiceHud_ hide];
        voiceHud_ = nil;
    }
    
    if (yesOrNo) {
        
        voiceHud_ = [[LCVoiceHud alloc] init];
        [voiceHud_ show];
        
    }else{
        
    }
}

-(void) resetTimer
{    
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

-(void) cancelRecording
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
}

- (void)cancelled
{
    [[NSFileManager defaultManager] removeItemAtPath:self.recordPath error:nil];
    [self showVoiceHudOrHide:NO];
    [self resetTimer];
    [self cancelRecording];
}

#pragma mark - LCVoiceHud Delegate

-(void) LCVoiceHudCancelAction
{
    [self cancelled];
}

@end
