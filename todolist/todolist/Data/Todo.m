//
//  Todo.m
//  todolist
//
//  Created by FanFamily on 15/4/26.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "Todo.h"

@implementation Todo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.subject = @"未知主题";
        self.detail = @"未知详情";
        self.create_data = [NSDate date];
        self.status = @(kTodoStatusNoDo);
        self.priority = @"";
    }
    return self;
}

@end
