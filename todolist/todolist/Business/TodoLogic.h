//
//  TodoLogic.h
//  todolist
//
//  Created by FanFamily on 15/4/26.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Todo.h"

@interface TodoLogic : NSObject

// 添加一条新的待办
+ (void)createNewTodo:(Todo *)todo finishCreate:(void(^)(id result))finishCreate;

// 移动一条待办在另一条待办之上, 如果destTodoId是nil，移动置最底层
+ (void)putOnAnotherTodoWithSrcTodoId:(NSNumber *)srcTodoId withDestTodoId:(NSNumber *)destTodoId finish:(void(^)(NSNumber* destTodoId))finish;

// 将待办置顶
+ (void)putTodoAtTop:(NSNumber *)todoId;

// 将待办置底
+ (void)putTodoAtBottom:(NSNumber *)todoId;

// 返回待办列表
+ (NSArray *)queryTodoList;

// 返回子待办
+ (NSArray *)queryTodoChildList:(NSNumber *)parentId;

// 返回date标记的日期的待办列表
+ (NSArray *)queryDayTodoListWithDate:(NSDate *)date;

// 根据todoId返回待办
+ (Todo *)queryTodoWithId:(NSNumber *)todoId;

// 更新待办
+ (void)updateTodo:(Todo *)todo finish:(void(^)(id result))finish;

// 删除待办, 连同子任务
+ (void)deleteTodo:(NSNumber *)todoId;

// 添加提醒
+ (void)addTodoNotification:(Todo *)todo date:(NSDate *)date;

// 取消提醒
+ (void)removeTodoNotification:(NSNumber *)todoId;

@end
