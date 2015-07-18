//
//  TodoListTableView.h
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TodoListTableViewCell;
@protocol TodoListTableViewDelegate <NSObject>

- (void)cellSelect:(TodoListTableViewCell *)cell;

@end

@class Todo;
@interface TodoListTableView : UITableView

@property (nonatomic, assign) id<TodoListTableViewDelegate> todoListTableViewDelegate;

- (void)addTodo:(Todo *)todo;

- (NSArray *)getTodoList;

@end
