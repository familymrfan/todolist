//
//  TodoDetailTableView.h
//  todolist
//
//  Created by FanFamily on 15/7/16.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TodoListTableViewCell;
@protocol TodoDetailTableViewDelegate <NSObject>

- (void)cellSelect:(TodoListTableViewCell *)cell;

@end

@class Todo;
@interface TodoDetailTableView : UITableView

@property (nonatomic, assign) id<TodoDetailTableViewDelegate> todoDetailTableViewDelegate;

@property (nonatomic) Todo* todo;
@property (nonatomic) NSMutableArray* todolist;

@end
