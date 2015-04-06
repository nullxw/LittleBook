//
//  LBDragContainer.h
//  LittleBook
//
//  Created by hupeng on 15/4/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBDragContainer;

@protocol LBDragContainerResponseDelegate

- (void)container:(LBDragContainer *)container didMoveItemToRect:(CGRect)rect;

// if return true - dragged item will remain in response area
// else - dragged item will be placed back to original area
- (BOOL)draggedItemShouldLeftWhileContainerWillDismiss:(LBDragContainer *)container;

@end

@protocol LBDragContainerResourceDelegate

- (UIView *)setupItemOfContainer:(LBDragContainer *)container;


- (void)containerWillDismiss:(LBDragContainer *)container withDraggedItemBack:(BOOL)flag;

@end

@interface LBDragContainer : NSObject

@property (nonatomic, weak) IBOutlet id<LBDragContainerResponseDelegate> responseDelegate;

@property (nonatomic, weak) IBOutlet id<LBDragContainerResourceDelegate> resourceDelegate;

@property (nonatomic, strong) UIView *draggedItem;

+ (LBDragContainer *)shareContainer;

- (void)updateItemAtPoint:(CGPoint)point;

- (void)show;
- (void)hide;
//+ (LBDragContainer *)canvasWithItem:(UIImage *)image
//                      atPosition:(CGPoint)point
//                          inRect:(CGRect)containerRect;



@end
