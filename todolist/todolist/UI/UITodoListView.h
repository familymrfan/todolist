//
//  UITodoListView.h
//  todolist
//
//  Created by FanFamily on 15/5/24.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMoveTableView.h"

@protocol UITodoListViewDelegate <NSObject>

@optional
- (void)touchInTodoListView;

@end

@interface UITodoListView : FMMoveTableView

@property (nonatomic, weak) id<UITodoListViewDelegate> todoListViewDelegate;

@end
