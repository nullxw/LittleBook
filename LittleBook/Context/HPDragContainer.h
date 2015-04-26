//
//  HPDragContainer.h
//  LittleBook
//
//  Created by hupeng on 15/4/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HPDragContainer;

@protocol HPDragContainerResponseDelegate

- (void)container:(HPDragContainer *)container didMoveItemToRect:(CGRect)rect;

// if return true - dragged item will remain in response area
// else - dragged item will be placed back to original area
- (BOOL)draggedItemShouldLeftWhileContainerWillDismiss:(HPDragContainer *)container;

@end

@protocol HPDragContainerResourceDelegate

- (UIView *)setupItemOfContainer:(HPDragContainer *)container;


- (void)containerWillDismiss:(HPDragContainer *)container withDraggedItemBack:(BOOL)flag;

@end

@interface HPDragContainer : NSObject

@property (nonatomic, weak) IBOutlet id<HPDragContainerResponseDelegate> responseDelegate;

@property (nonatomic, weak) IBOutlet id<HPDragContainerResourceDelegate> resourceDelegate;

@property (nonatomic, strong) UIView *draggedItem;

+ (HPDragContainer *)shareContainer;

- (void)updateItemAtPoint:(CGPoint)point;

- (void)show;
- (void)hide;
//+ (HPDragContainer *)canvasWithItem:(UIImage *)image
//                      atPosition:(CGPoint)point
//                          inRect:(CGRect)containerRect;



@end
