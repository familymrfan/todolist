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

@protocol UITodoDetailViewDelegate <NSObject>

- (void)todoSubjectChanged:(NSString *)subject todoId:(NSNumber *)todoId;
- (void)todoDelete:(NSNumber *)todoId;

@end

@interface UITodoDetailView : UIView

@property (nonatomic, weak) id<UITodoDetailViewDelegate> delegate;
@property (nonatomic, assign) TodoDetailViewStatus todoDetailViewStatus;

- (void)showWithTodoId:(NSNumber *)todoId;
- (void)hide;

@end
