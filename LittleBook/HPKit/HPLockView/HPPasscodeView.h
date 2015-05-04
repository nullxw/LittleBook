//
//  HPPasscodeView.h
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/7.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    
    HPPasscodeStatusTypeEnablePasscode, // start enable a passcode
    HPPasscodeStatusTypeReEnablePasscode, //
    HPPasscodeStatusTypeConfirmPasscode, // u set a passcode, then u confirm it
    HPPasscodeStatusTypeResetPasscode,
    HPPasscodeStatusTypeDisablePasscode,
    HPPasscodeStatusTypeVerifyPasscode, // u have setted a passcode, then u check it
    HPPasscodeStatusTypeShowPasscode
} HPPasscodeStatusType;


@protocol HPPasscodeViewImp <NSObject>

- (void)initPasscodeView;

- (NSString *)currentPasscode;
- (void)prepareForErrorStatus;
- (void)updatePasscodeViewStatus;
- (void)didEndInputing;

@end

@class HPPasscodeView;

@protocol HPPasscodeViewDelegate <NSObject>

@optional

// tryTime start from 1
- (void)passcodeView:(HPPasscodeView *)passcodeView inputWrongPasscodeWithTryTime:(int)tryTime;
- (void)passcodeView:(HPPasscodeView *)passcodeView willChangeStatusFrom:(HPPasscodeStatusType)fromStatus to:(HPPasscodeStatusType)toStatus;

- (BOOL)checkInputPasscode:(NSString *)passcode;
- (void)passcodeViewDidBeginInput:(HPPasscodeView *)passcodeView;
- (void)passcodeViewDidEnablePasscode:(HPPasscodeView *)passcodeView;
- (void)passcodeViewDidDeletePasscode:(HPPasscodeView *)passcodeView;
- (void)passcodeViewDidVerifiedPasscode:(HPPasscodeView *)passcodeView;

@end

@protocol HPPasscodeStorePolicy <NSObject>

@required
- (BOOL)hasPasscode;
- (void)savePasscode:(NSString *)passcode;
- (void)deletePasscode;
- (NSString *)passcode;
- (NSString *)passcodeFromOutput:(id)passcode;

@optional
- (BOOL)passcodeToVerifyIsValid:(NSString *)passcode;
- (BOOL)inputPasscodeIsValid:(NSString *)passcode;

@end

@interface HPPasscodeView : UIView <HPPasscodeViewImp>

@property (nonatomic, assign) IBOutlet id<HPPasscodeViewDelegate> delegate;

@property (nonatomic, assign) IBOutlet id<HPPasscodeStorePolicy> passcodeStorePolicy;

@property (nonatomic, assign) HPPasscodeStatusType currentStateType;

@property (nonatomic, assign) BOOL isErrorStatus;

@end
