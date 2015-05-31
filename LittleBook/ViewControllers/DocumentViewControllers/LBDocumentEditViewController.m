//
//  EditViewController.m
//  LittleBook
//
//  Created by 胡鹏 on 15/3/14.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#define LB_DOCUMENT_APPENDIX_START_TAG 999
#define LB_DOCUMENT_CONTENT_OY_NOMARL  80
#define LB_DOCUMENT_CONTENT_OY_EDIT    275
#define LB_DOCUMENT_CONTENT_FIELD_OY   49
#define LB_DOCUMENT_TOOLBAR_HEIGHT     30
#import "LBDocumentEditViewController.h"
#import "UIViewController+LBSegueExt.h"
#import "LBDocumentAppendixEditView.h"
#import "UITextView+TextViewExt.h"
#import "LBReadFileFileManager.h"
#import "LBAppendixFileManager.h"
#import "LBPanelStyleManager.h"
#import "LBIndexInfoManager.h"
#import "LBReadFileManager.h"
#import "LBAppendixManager.h"
#import "LBDocumentContext.h"
#import "HPTouchImageView.h"
#import "LBExportManager.h"
#import "HPDragContainer.h"
#import "LBSectionView.h"
#import "FSVoiceBubble.h"
#import "LBAppContext.h"
#import "Appendix.h"
#import "Document.h"
#import "LCVoice.h"


@interface LBDocumentEditViewController () <UITextFieldDelegate, UITextViewDelegate, HPDragContainerResponseDelegate, HPTouchImageViewProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL _isMediaEditViewVisible;
    
    NSMutableArray *_appendixs;
    NSMutableArray *_appendixViews;
    NSMutableArray *_appendixPaths;
    
    LBExportManager *_exportManager;
    
    NSInteger _previousCursorLocation;
    
    LCVoice *_voice;
}
@property (weak, nonatomic) IBOutlet LBSectionView *sectionView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;

@property (weak, nonatomic) IBOutlet LBDocumentAppendixEditView *editContainerView;

@property (nonatomic, strong) UIDocumentInteractionController *documentViewController;

@property (weak, nonatomic) IBOutlet UIView *dummyView;
@property (weak, nonatomic) IBOutlet UIView *toolBar;

@end

@implementation LBDocumentEditViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _doc = [[LBDocumentContext defaultContext] prepareContext:_doc];
    // 1. init params
    [HPDragContainer shareContainer].responseDelegate = self;
    
    _isMediaEditViewVisible = FALSE;
    
    // 2. update UI
    _sectionView.sectionNumber = 3;
    _sectionView.separateLineColor = LB_LIGHT_GRAY_LINE_COLOR;
    
    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
    
    float offsetY = editViewHeight - 25;
    _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame) - offsetY, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame) + offsetY);
    
    _contentField.editable = TRUE;
    _contentField.selectable = TRUE;
    
    [self updateInterfaceWithSettings];
    [self updateInterfaceWithDocument];
    
    // 3. register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseToAction:) name:LB_ACTION_NOTIF object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    _contentField.selectable = TRUE;
//    _contentField.text = _doc.content;
}

- (void)updateInterfaceWithSettings
{
    NSDictionary *settings = [LBAppContext context].settings;
    
    int fontSize = [settings[kLBFontSizeSetting] intValue];
    PanelStyle *currentStyle = [[LBPanelStyleManager defaultManager] currentStyle];
    
    _toolBar.backgroundColor = currentStyle.panelColor;
    _contentView.backgroundColor = currentStyle.panelColor;
    _dummyView.backgroundColor = currentStyle.panelColor;
    
    _contentField.textColor = currentStyle.fontColor;
    _titleField.textColor   = currentStyle.fontColor;
    
    _contentField.font = [UIFont fontWithName:_contentField.font.fontName size:fontSize];
    _titleField.font = [UIFont fontWithName:_titleField.font.fontName size:fontSize + 2];
}

- (void)updateInterfaceWithDocument
{
    _titleField.text = _doc.title;

    _contentField.text = _doc.content;
    
    NSArray *appendixs = [LBAppendixManager appendixs:_doc.documentID];
    
    _appendixs = [[NSMutableArray alloc] initWithCapacity:0];
    _appendixViews = [[NSMutableArray alloc] initWithCapacity:0];
    _appendixPaths = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (appendixs) {
        [_appendixs addObjectsFromArray:appendixs];
    }
    for (Appendix *appendix in appendixs) {
        [self creatAppendixViewWithAppendix:appendix];
    }
    
    _contentField.textContainer.exclusionPaths = _appendixPaths;
}

- (float)getMaxYOfTextView
{
    float oY = [_contentField maxContentSizeY];
    
    for (UIView *appendixView in _appendixViews) {
        oY = MAX(oY, CGRectGetMaxY(appendixView.frame));
    }
    return oY + 5;
}

- (void)creatAppendixViewWithAppendix:(Appendix *)appendix
{
    NSString *appendixPath = [[LBAppendixFileManager defaultManager] pathForAppendix:appendix.appendixID];
    
    CGRect frame = CGRectZero;
    
    NSDictionary *settings = [LBAppContext context].settings;
    
    BOOL dragEnable = [settings[kLBDragSetting] boolValue];
    
    BOOL resizeEnable = [settings[kLBResizeSetting] boolValue];
    
    if ([appendix.type integerValue] == LBAppendixTypeAudio) {
        
        if (!appendix.frame) {
            frame = CGRectMake(0, [self getMaxYOfTextView], 110, 30);
            appendix.frame = NSStringFromCGRect(frame);
        } else {
            frame = CGRectFromString(appendix.frame);
        }
        FSVoiceBubble *voiceBubble = [[FSVoiceBubble alloc] initWithFrame:frame];
        voiceBubble.tag = LB_DOCUMENT_APPENDIX_START_TAG + appendix.appendixID.intValue;
        voiceBubble.disablePan = !dragEnable;
        voiceBubble.duration = [appendix.duration intValue];
        voiceBubble.durationInsideBubble = YES;
        voiceBubble.touchDelegate = self;
        voiceBubble.contentURL = [NSURL fileURLWithPath:appendixPath];
        [_appendixViews addObject:voiceBubble];
        [_appendixPaths addObject:[self exclusionPathForFrame:voiceBubble.frame]];
        [_contentField addSubview:voiceBubble];
        
    } else {
        
        CGRect frame = CGRectFromString(appendix.frame);
        
        HPTouchImageView *appendixView = [[HPTouchImageView alloc] initWithFrame:frame];
        appendixView.disablePan = !dragEnable;
        appendixView.disablePinch = !resizeEnable;
        appendixView.image    = [UIImage imageWithContentsOfFile:appendixPath];
        appendixView.touchDelegate = self;
        appendixView.tag      = LB_DOCUMENT_APPENDIX_START_TAG + appendix.appendixID.intValue;
        
        [_appendixViews addObject:appendixView];
        [_appendixPaths addObject:[self exclusionPathForFrame:frame]];
        
        [_contentField addSubview:appendixView];
    }
}

- (UIBezierPath *)exclusionPathForFrame:(CGRect)frame
{
    float offset = _contentField.font.pointSize * 0.5;
    
    return [UIBezierPath bezierPathWithRect:CGRectMake(frame.origin.x - offset, frame.origin.y - offset, frame.size.width + 2 * offset, frame.size.height)];
}

#pragma mark - button events

- (IBAction)editButtonClicked:(UIButton *)sender
{
    _isMediaEditViewVisible = !_isMediaEditViewVisible;
    
    sender.enabled = FALSE;
    
    float editViewHeight = CGRectGetHeight(_editContainerView.bounds);
    float halfToolBarHeight = 25;
    
    if (_editButton.tag == 0) {
        // open edit panel
        [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            _editContainerView.frame = CGRectMake(0, halfToolBarHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
            
            _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), LB_DOCUMENT_CONTENT_OY_EDIT, CGRectGetWidth(_contentView.bounds), CGRectGetHeight(_contentView.bounds) - LB_DOCUMENT_CONTENT_OY_EDIT + LB_DOCUMENT_CONTENT_OY_NOMARL);
            
        } completion:^(BOOL finished) {
            _editButton.enabled = TRUE;
            [self hideKeyboardButtonClicked:nil];
        }];
        
    } else {
        
        // close edit panel
        [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
            _editContainerView.frame = CGRectMake(0, -editViewHeight, CGRectGetWidth(_editContainerView.bounds), editViewHeight);
            
            _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), LB_DOCUMENT_CONTENT_OY_NOMARL, CGRectGetWidth(_contentView.bounds), CGRectGetHeight(_contentView.bounds) + LB_DOCUMENT_CONTENT_OY_EDIT - LB_DOCUMENT_CONTENT_OY_NOMARL);
            
        } completion:^(BOOL finished) {
            _editButton.enabled = TRUE;
        }];
    }
    _editButton.tag = !_editButton.tag;
}
- (IBAction)hideKeyboardButtonClicked:(id)sender
{
    [_titleField resignFirstResponder];
    [_contentField resignFirstResponder];
}

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self extendTextField];
    UIImage *image = [_contentView toImage];
    
    [[LBReadFileFileManager defaultManager] saveReadFileImage:_doc.documentID withData:UIImageJPEGRepresentation(image, 0.6)];
    [self contractTextField];

    [[LBDocumentContext defaultContext] saveContext];
    [self dismissViewControllerPresentFromBottonWithMovingDirection:HPPresentViewMovingDirectionDown];
}

-(IBAction)audioButtonTouchDown:(id)sender
{
    [self hideKeyboardButtonClicked:nil];
    
    if (!_voice) {
        _voice = [[LCVoice alloc] init];
    }
    [_voice startRecordWithPath:nil];
}

-(IBAction)audioButtonUpInside:(id)sender
{
    [_voice stopRecordWithCompletionBlock:^{
        if (_voice.recordTime > 1.0f) {
            Appendix *appendix =[LBAppendixManager createAudioAppendixWithFilePath:_voice.recordPath andDuration:_voice.recordTime];
            appendix.parentID = _doc.documentID;
            [_appendixs addObject:appendix];
            [self creatAppendixViewWithAppendix:appendix];
            _contentField.textContainer.exclusionPaths = _appendixPaths;
        }
    }];
}

-(IBAction)audioButtonUpOutside:(id)sender
{
    [_voice cancelled];
}
- (IBAction)cameraButtonClicked:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    [_titleField resignFirstResponder];
    [_contentField resignFirstResponder];
    
    UIImagePickerController *cameraViewController = [[UIImagePickerController alloc] init];
    cameraViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraViewController.delegate = self;
    [self presentViewController:cameraViewController animated:YES completion:^{
        
    }];
}
- (IBAction)leftArrowButtonClicked:(id)sender
{
    [_contentField moveCursor:-1];
}

- (IBAction)rightArrowClicked:(id)sender
{
    [_contentField moveCursor:1];
}

- (IBAction)topArrowClicked:(id)sender
{
    [_contentField moveCursorToPreviousLine];
}
#pragma mark - action handlers

- (void)extendTextField
{
    CGRect contentFieldFrame = _contentField.frame;
    int oHeight = CGRectGetHeight(contentFieldFrame);
    
    int height = MAX(_contentField.contentSize.height, oHeight);
    contentFieldFrame.size.height = height;
    
    CGRect contentViewFrame = _contentView.frame;
    int dH = height - oHeight;
    contentViewFrame.size.height += dH;
    _contentView.frame = contentViewFrame;
    _contentField.frame = contentFieldFrame;
    _toolBar.hidden = TRUE;
}

- (void)contractTextField
{
    int contentViewHeight = CGRectGetHeight(self.view.frame) - CGRectGetMinY(_contentView.frame);
    
    CGRect contentViewFrame = _contentView.frame;
    contentViewFrame.size.height = contentViewHeight;
    _contentView.frame = contentViewFrame;
    
    CGRect contentFieldFrame = _contentField.frame;
    
    int contentFieldHeight = contentViewHeight - LB_DOCUMENT_CONTENT_FIELD_OY - LB_DOCUMENT_TOOLBAR_HEIGHT;
    
    contentFieldFrame.size.height = contentFieldHeight;
    _contentField.frame = contentFieldFrame;
    
    _toolBar.hidden = FALSE;
}


- (void)insertAppendixWithInfo:(NSDictionary *)appendixInfo
{
    [self editButtonClicked:_editButton];
    CGSize appendixSize = CGSizeFromString(appendixInfo[@"size"]);
    
    CGRect frame = CGRectMake(0, [self getMaxYOfTextView], appendixSize.width, appendixSize.height);
    
    // creat Appendix
    Appendix *appendix = [[LBDocumentContext defaultContext] addAppendix:appendixInfo[@"image"] type:LBAppendixTypeImage];
    appendix.frame = NSStringFromCGRect(frame);
    [_appendixs addObject:appendix];
    [self creatAppendixViewWithAppendix:appendix];
    
    float offsetY = CGRectGetMaxY(frame) - CGRectGetHeight(_contentField.frame);
    offsetY = MAX(0, offsetY);
    
    _contentField.contentOffset = CGPointMake(0, offsetY);
}

- (void)exportAsPDF
{
    if (_editButton) {
        [self editButtonClicked:_editButton];
    }
    
    [self extendTextField];
    [LBExportManager exportDocument:_doc asPDF:_contentView];
    [self contractTextField];
}

- (void)exportToLocal
{
    if (_editButton) {
        [self editButtonClicked:_editButton];
    }
    
    if (!_exportManager) {
        _exportManager = [[LBExportManager alloc] init];
    }
    
    [self extendTextField];
    UIImage *image = [_contentView toImage];
    [_exportManager exportToLocal:image];
    [self contractTextField];
}

- (void)exportAsDoc
{
    [self backButtonClicked:nil];
}

- (void)openIn
{
    if (_editButton) {
        [self editButtonClicked:_editButton];
    }    
    if (!_exportManager) {
        _exportManager = [[LBExportManager alloc] init];
    }
    [self extendTextField];
    UIImage *image = [_contentView toImage];
    [_exportManager openDocImage:image withHolder:self];
    [self contractTextField];
}

#pragma mark - notification handlers

- (void)responseToAction:(NSNotification *)notif
{
    LBActionType actionType = [notif.userInfo[LB_ACTION_TYPE_KEY] intValue];
    
    if (actionType == LBActionTypeInsertAppendix) {
        [self insertAppendixWithInfo:notif.object];
    } else if (actionType == LBActionTypeSaveAsDoc) {
        [self exportAsDoc];
    } else if (actionType == LBActionTypeSaveAsPDF) {
        [self exportAsPDF];
    } else if (actionType == LBActionTypeSaveToLocal) {
        [self exportToLocal];
    } else if (actionType == LBActionTypeOpenIn) {
        [self openIn];
    }
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    float kbHeight = kbSize.height;
    
    float oY =  _isMediaEditViewVisible ? LB_DOCUMENT_CONTENT_OY_EDIT : LB_DOCUMENT_CONTENT_OY_NOMARL;
    
    [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
        
        _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), oY, CGRectGetWidth(_contentView.bounds), CGRectGetHeight(self.view.bounds) - oY - kbHeight);
        
    } completion:^(BOOL finished) {
        
        if (_isMediaEditViewVisible) {
            [self editButtonClicked:_editButton];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    float oY =  _isMediaEditViewVisible ? LB_DOCUMENT_CONTENT_OY_EDIT : LB_DOCUMENT_CONTENT_OY_NOMARL;
    
    [UIView animateWithDuration:LB_LINEAR_ANIMATION_TIME animations:^{
        _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), oY, CGRectGetWidth(_contentView.bounds), CGRectGetHeight(self.view.bounds) - oY);
        
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *title = textField.text;
    
    if ([string isEqualToString:@""] && title.length > 0) {
        title = [title substringToIndex:title.length - 1];
    } else if ([string isEqualToString:@"\n"]){
        [_contentField becomeFirstResponder];
        return FALSE;
    } else {
        title = [title stringByReplacingCharactersInRange:range withString:string];
    }
    _doc.title = title;
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return TRUE;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = textView.text;
    if ([text isEqualToString:@""] && content.length > 0) {
        content = [content substringToIndex:content.length - 1];
    } else {
        content = [content stringByReplacingCharactersInRange:range withString:text];
    }
    _doc.content = content;
    return TRUE;
}
#pragma mark - HPDragContainerResponseDelegate

- (void)container:(HPDragContainer *)container didMoveItemToRect:(CGRect)rect
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    CGRect contentFieldFrame = [win convertRect:_contentField.frame fromView:_contentView];
    
    // 1.  图片进入文本区域
    if (CGRectContainsRect(contentFieldFrame, container.draggedItem.frame)) {
        
        // 1.1 隐藏编辑区
        if (_isMediaEditViewVisible) {
            [self editButtonClicked:nil];
        }
        
        CGRect frameInField = [_contentField convertRect:container.draggedItem.frame fromView:win];
        float offset = _contentField.font.pointSize * 0.5;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(frameInField.origin.x - offset, frameInField.origin.y - offset, frameInField.size.width + 2 * offset, frameInField.size.height)];
        NSMutableArray *tempPaths = _appendixPaths.mutableCopy;
        [tempPaths addObject:path];
        
        _contentField.textContainer.exclusionPaths = tempPaths;
        
    } else {
        _contentField.textContainer.exclusionPaths = _appendixPaths;
    }
}

- (BOOL)draggedItemShouldLeftWhileContainerWillDismiss:(HPDragContainer *)container
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    
    // 编辑菜单隐藏了说明 图片已经进入文本区域了
    if (!_isMediaEditViewVisible) {
        
        // creat Appendix
        
        UIImageView *draggedItem = (UIImageView *)container.draggedItem;
        CGRect appendixViewFrame = [_contentField convertRect:draggedItem.frame fromView:win];
        
        Appendix *appendix = [[LBDocumentContext defaultContext] addAppendix:draggedItem.image type:LBAppendixTypeImage];
        appendix.frame = NSStringFromCGRect(appendixViewFrame);
        
        [_appendixs addObject:appendix];
        
        [self creatAppendixViewWithAppendix:appendix];
    }
    
    return !_isMediaEditViewVisible;
}

#pragma mark - HPTouchImageViewProtocol

- (void)didRemoveTouchImageView:(HPTouchImageView *)touchImageView
{
    NSInteger selectedIndex = [_appendixViews indexOfObject:touchImageView];
    
    // update appendix
    Appendix *appendix = [_appendixs objectAtIndex:selectedIndex];
    
    [LBAppendixManager deleteAppendix:appendix];
    
    [_appendixPaths removeObjectAtIndex:selectedIndex];
    [_appendixs removeObjectAtIndex:selectedIndex];
    [_appendixViews removeObjectAtIndex:selectedIndex];
    
    // update content field
    _contentField.textContainer.exclusionPaths = _appendixPaths;

}

- (CGRect)verifiedFrame:(CGRect)frame
{
    float w = CGRectGetWidth(_contentField.bounds);
    
    if (CGRectGetMaxX(frame) > w) {
        frame.origin.x = w - CGRectGetWidth(frame);
    }
    
    if (CGRectGetMinX(frame) < 0) {
        frame.origin.x = 0;
    }
    
    if (CGRectGetMinY(frame) < 0) {
        frame.origin.y = 0;
    }
    
    if (frame.size.width > w) {
        
        float ratio = frame.size.height/frame.size.width;
        
        frame.size.width = w;
        frame.size.height = w * ratio;
        
    }
    
    return frame;
}

- (void)didTapTouchImageView:(HPTouchImageView *)touchImageView
{
    [self hideKeyboardButtonClicked:nil];
}

- (void)willOperateTouchImageView:(HPTouchImageView *)touchImageView
{
    [self hideKeyboardButtonClicked:nil];
    
    _contentField.scrollEnabled = FALSE;
    
    CGRect frame = _contentField.frame;
    frame.origin.y = frame.origin.y - _contentField.contentOffset.y;
    frame.size.height = MAX(_contentField.contentSize.height, CGRectGetHeight(frame));
    _contentField.frame = frame;
    
}

- (void)didOperateTouchImageView:(HPTouchImageView *)touchImageView
{
    CGRect frame = touchImageView.frame;
    
    NSInteger selectedIndex = [_appendixViews indexOfObject:touchImageView];
    
    // update appendix
    Appendix *appendix = [_appendixs objectAtIndex:selectedIndex];
    appendix.frame = NSStringFromCGRect(frame);
    
    // update path infos
    UIBezierPath *path = [self exclusionPathForFrame:frame];
    [_appendixPaths replaceObjectAtIndex:selectedIndex withObject:path];
    
    // update content field
    _contentField.textContainer.exclusionPaths = _appendixPaths;
}

- (void)didEndOperateTouchImageView:(HPTouchImageView *)touchImageView
{
    _contentField.scrollEnabled = TRUE;
    
    float offsetY = LB_DOCUMENT_CONTENT_FIELD_OY - CGRectGetMinY(_contentField.frame);
    
    CGRect frame = _contentField.frame;
    frame.origin.y = LB_DOCUMENT_CONTENT_FIELD_OY;
    frame.size.height = CGRectGetHeight(_contentView.bounds) - LB_DOCUMENT_CONTENT_FIELD_OY - LB_DOCUMENT_TOOLBAR_HEIGHT;
    _contentField.frame = frame;
    offsetY = MAX(0, offsetY);
    _contentField.contentOffset = CGPointMake(0, offsetY);
}

#pragma mark -  UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (!_isMediaEditViewVisible) {
            [self editButtonClicked:_editButton];
            [UIView animateWithDuration:LB_SPRING_ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                _contentView.frame = CGRectMake(CGRectGetMinX(_contentView.frame), LB_DOCUMENT_CONTENT_OY_EDIT, CGRectGetWidth(_contentView.frame), CGRectGetHeight(self.view.bounds) - LB_DOCUMENT_CONTENT_OY_EDIT);
                
            } completion:^(BOOL finished) {
                
            }];
        }
        [_editContainerView addImageToEdit:image];
    }];
}

@end