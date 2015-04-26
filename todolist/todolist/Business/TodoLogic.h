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

@end
