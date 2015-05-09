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
+ (void)putOnAnotherTodoWithSrcTodoId:(NSNumber *)srcTodoId withDestTodoId:(NSNumber *)destTodoId finish:(void(^)(id result))finish;

// 返回date标记的日期的待办列表
+ (NSArray *)queryDayTodoListWithDate:(NSDate *)date;

@end
