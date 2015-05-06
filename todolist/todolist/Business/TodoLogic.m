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
        return @"B";
    }
    
    NSMutableString* newPriority = [NSMutableString stringWithString:priority];
    unichar last_c = [newPriority characterAtIndex:newPriority.length-1];
    if (last_c == 'Z') {
        [newPriority appendString:@"B"];
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
        todo.create_date = [NSDate date];
        todo.priority = priority;
        todo.status = @(kTodoStatusNoDo);
        [[DataLibrary saver] save:todo];
        finishBlock(nil);
        finishCreate(nil);
    }];
}

+ (void)putOnAnotherTodoWithSrcTodoId:(NSNumber *)srcTodoId withDestTodoId:(NSNumber *)destTodoId finish:(void(^)(id result))finish
{
    [QueueManager asyncDoWorkBlock:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
        NSString* destTodoPriority = nil;
        if (destTodoId == nil) {
            destTodoPriority = @"A";
        } else {
            NSArray* todos = [[DataLibrary querier] query:[Todo class] otherCondition:@"where rowId = ?" withParam:@[destTodoId]];
            if ([todos count] != 1) {
                NSLog(@"can not find destTodoId %@ !", destTodoId);
                return ;
            }
            Todo* destTodo = todos.firstObject;
            destTodoPriority = destTodo.priority;
        }
        NSString* upTodoPriority = nil;
        NSString* srcTodoPriority = nil;
        NSArray* todos = [[DataLibrary querier] query:[Todo class] otherCondition:@"where priority > ? order by priority limit 1" withParam:@[destTodoPriority]];
        // top insert
        if ([todos count] == 0) {
            srcTodoPriority = [self risePriority:destTodoPriority];
        } else {
            assert([todos count] == 1);
            Todo* upTodo = todos.firstObject;
            upTodoPriority = upTodo.priority;
            srcTodoPriority = [destTodoPriority stringByAppendingString:upTodoPriority];
        }
        Todo* updateTodo = [[Todo alloc] init];
        updateTodo.rowId = srcTodoId;
        updateTodo.priority = srcTodoPriority;
        [[DataLibrary saver] save:updateTodo];
        finishBlock(nil);
        finish(nil);
    }];
}

@end
