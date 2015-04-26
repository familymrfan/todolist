//
//  TodoLogic.m
//  todolist
//
//  Created by FanFamily on 15/4/26.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoLogic.h"
#import "DataLibrary.h"
#import "QueueManager.h"

@implementation TodoLogic

+ (NSString *)pickMaxPriority
{
    NSArray* todos = [[DataLibrary querier] query:[Todo class] otherCondition:@"where priority=(select max(priority) from Todo)" withParam:nil];
    if (todos.count != 1) {
        return nil;
    }
    Todo* todo = todos.firstObject;
    return todo.priority;
}

+ (NSString *)risePriority:(NSString *)priority
{
    if (priority.length == 0) {
        return @"A";
    }
    
    NSMutableString* newPriority = [NSMutableString stringWithString:priority];
    unichar last_c = [newPriority characterAtIndex:newPriority.length-1];
    if (last_c == 'Z') {
        [newPriority appendString:@"A"];
    } else {
        last_c = (unichar)(last_c + 1);
        [newPriority replaceCharactersInRange:NSMakeRange(newPriority.length - 1, 1) withString:[NSString stringWithFormat:@"%c", last_c]];
    }
    return newPriority;
}

+ (void)createNewTodo:(Todo *)todo finishCreate:(void(^)(id result))finishCreate
{
    [QueueManager asyncDoWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        NSString* priority = [self risePriority:[self pickMaxPriority]];
        assert(priority);
        todo.priority = priority;
        [[DataLibrary saver] save:todo];
        finishBlock(nil);
        finishCreate(nil);
    }];
}

@end
