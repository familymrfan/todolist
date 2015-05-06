//
//  todolistTests.m
//  todolistTests
//
//  Created by FanFamily on 15/4/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TodoLogic.h"
#import "Todo.h"

@interface todolistTests : XCTestCase

@end

@implementation todolistTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (Todo *)buildTodo
{
    Todo* todo = [[Todo alloc] init];
    todo.subject = @"蛋卷该吃饭了";
    todo.detail = [NSString stringWithFormat:@"%d", arc4random() % 10000];
    return todo;
}

- (void)testTodoLogicCreateTodo
{
    Todo* todo = [self buildTodo];
    [TodoLogic createNewTodo:todo finishCreate:^(id result) {
        [TodoLogic putOnAnotherTodoWithSrcTodoId:@18 withDestTodoId:nil finish:^(id result) {
            
        }];
    }];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
}

@end
