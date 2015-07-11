//
//  TodoListTableView.m
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoListTableView.h"
#import "TodoLogic.h"
#import "TodoListTableViewCell.h"
#import "QueueManager.h"

@interface TodoListTableView () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic) NSMutableArray* todoList;
@property (nonatomic) TodoListTableViewCell* cellRightStatus;

@end

@implementation TodoListTableView

-(void)awakeFromNib
{
    self.todoList = [NSMutableArray arrayWithArray:[TodoLogic queryDayTodoList]];
    [self setDelegate:self];
    [self setDataSource:self];
}

- (void)addTodo:(Todo *)todo
{
    [TodoLogic createNewTodo:todo finishCreate:^(id result) {
        [QueueManager asyncDoWorkBlockInMainQueue:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
            [self.todoList insertObject:todo atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }];
}

#pragma marks UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todoList.count;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Del"];
    
    return rightUtilityButtons;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoListTableViewCell* cell = [self dequeueReusableCellWithIdentifier:@"todoCellIdentifier"];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:50];
    [cell setDelegate:self];
    Todo* todo = [self.todoList objectAtIndex:indexPath.row];
    if (todo.subject) {
        [cell.todoLabel setText:todo.subject];
    }
    return cell;
}

#pragma marks UITableViewDelegate method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UIViewController* todoDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"todoDetailViewControllerIdentity"];
    //[self.superview.navigationController pushViewController:todoDetailViewController animated:YES];
}

#pragma marks SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [self indexPathForCell:cell];
    Todo* todo = [self.todoList objectAtIndex:indexPath.row];
    [self.todoList removeObjectAtIndex:indexPath.row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [TodoLogic deleteTodo:todo.rowId];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

@end
