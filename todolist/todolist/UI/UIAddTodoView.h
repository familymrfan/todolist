//
//  UIAddTodoView.h
//  todolist
//
//  Created by FanFamily on 15/5/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIAddTodoViewDelegate <NSObject>

- (void)addTodoDone;

@end

@interface UIAddTodoView : UIView

@property (nonatomic, weak) id<UIAddTodoViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UITextField* addTodoTextField;

@end
