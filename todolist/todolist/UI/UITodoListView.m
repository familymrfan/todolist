//
//  UITodoListView.m
//  todolist
//
//  Created by FanFamily on 15/5/24.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "UITodoListView.h"

@implementation UITodoListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.todoListViewDelegate && [self.todoListViewDelegate respondsToSelector:@selector(touchInTodoListView)]) {
        [self.todoListViewDelegate touchInTodoListView];
    }
    return YES;
}

@end
