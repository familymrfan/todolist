//
//  UITodoListView.h
//  todolist
//
//  Created by FanFamily on 15/5/24.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMoveTableView.h"

@class UITableViewCell;
@protocol UITodoListViewDelegate <FMMoveTableViewDelegate>

@optional
- (BOOL)touchInTodoListView:(UITableViewCell *)cell;

@end

@interface UITodoListView : FMMoveTableView

@property (nonatomic, weak) id<UITodoListViewDelegate> todoListViewDelegate;

@end
