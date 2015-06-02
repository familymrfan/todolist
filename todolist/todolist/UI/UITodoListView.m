//
//  UITodoListView.m
//  todolist
//
//  Created by FanFamily on 15/5/24.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "UITodoListView.h"
#import "TodoTableViewCell.h"

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
    if ([event allTouches] && self.todoListViewDelegate && [self.todoListViewDelegate respondsToSelector:@selector(touchInTodoListView:)]) {
        
        TodoTableViewCell* cell = nil;
        NSIndexPath* indexPath = [self indexPathForRowAtPoint:point];
        if (indexPath) {
            cell = (TodoTableViewCell *)[self cellForRowAtIndexPath:indexPath];
        }
        
        return [self.todoListViewDelegate touchInTodoListView:cell];
    }
    return YES;
}

@end
