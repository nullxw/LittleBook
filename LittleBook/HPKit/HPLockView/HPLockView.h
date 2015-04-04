//
//  LockView.h
//  LockDemo
//
//  Created by 胡鹏 on 7/30/13.
//  Copyright (c) 2013 isoftStone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    
    HPLockViewStatusTypeEnablePasscode, // start enable a passcode
    HPLockViewStatusTypeReEnablePasscode, // 
    HPLockViewStatusTypeConfirmPasscode, // u set a passcode, then u confirm it
    HPLockViewStatusTypeChangePasscode,
    HPLockViewStatusTypeDisablePasscode,
    HPLockViewStatusTypeCheckPasscode // u have setted a passcode, then u check it
    
} HPLockViewStatusType;

@class HPLockView;

@protocol HPLockViewDelegate <NSObject>

@optional

// tryTime start from 1
- (void)lockView:(HPLockView *)lockView inputWrongPasscodeWithTryTime:(int)tryTime;
- (BOOL)checkInputPasscode:(NSString *)passcode;
- (void)lockViewDidBeginInput:(HPLockView *)lockView;
- (void)lockView:(HPLockView *)lockView willChangeStatusFrom:(HPLockViewStatusType)fromStatus to:(HPLockViewStatusType)toStatus;
- (void)lockViewDidEnablePasscode:(HPLockView *)lockView;
- (void)lockViewDidDeletePasscode:(HPLockView *)lockView;
- (void)lockViewDidCheckPasscode:(HPLockView *)lockView;

@end

@protocol HPLockViewPasscodeStorePolicy <NSObject>

@required
- (BOOL)hasPasscode;
- (void)savePasscode:(NSString *)passcode;
- (void)deletePasscode;
- (NSString *)passcode;
- (NSString *)currentPasscodeFromIndies:(NSArray *)indies;

@end

#ifdef IB_DESIGNABLE
IB_DESIGNABLE
#endif

@interface HPLockView: UIImageView

@property (nonatomic, assign) IBOutlet id<HPLockViewDelegate> delegate;

@property (nonatomic, assign) IBOutlet id<HPLockViewPasscodeStorePolicy> passcodeStorePolicy;

@property (nonatomic, assign) HPLockViewStatusType currentStateType;

@end
