//
//  TodoListTableView.h
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Todo;
@interface TodoListTableView : UITableView

- (void)addTodo:(Todo *)todo;

@end
