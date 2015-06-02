//
//  UITodoDetailView.h
//  todolist
//
//  Created by FanFamily on 15/6/2.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kTodoDetailViewHideStatus,
    kTodoDetailViewShowStatus
} TodoDetailViewStatus;

@interface UITodoDetailView : UIView

@property (nonatomic, assign) TodoDetailViewStatus todoDetailViewStatus;

- (void)show;
- (void)hide;

@end
