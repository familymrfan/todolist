//
//  Todo.h
//  todolist
//
//  Created by FanFamily on 15/4/26.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "MrObject.h"

typedef enum : NSUInteger {
    kTodoStatusNoDo,
    kTodoStatusDone
} TodoStatus;

@interface Todo : MrObject

@property (nonatomic) NSString* subject;
@property (nonatomic) NSString* detail;
@property (nonatomic) NSDate* create_date;
@property (nonatomic) NSDate* remind_date;
@property (nonatomic) NSNumber* status;
@property (nonatomic) NSString* priority;

@end
