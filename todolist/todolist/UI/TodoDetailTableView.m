//
//  TodoDetailTableView.m
//  todolist
//
//  Created by FanFamily on 15/7/16.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoDetailTableView.h"
#import "TodoListTableViewCell.h"
#import "TodoDetailAddChildTodoCell.h"
#import "TodoLogic.h"

@interface TodoDetailTableView () <UITableViewDataSource, UITableViewDelegate, TodoDetailAddChildTodoCellDelegate, SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *childTodoTextFieldAdd;


@end

@implementation TodoDetailTableView

-(void)awakeFromNib
{
    [self setDelegate:self];
    [self setDataSource:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return self.todolist.count + 1;
        case 2:
            return 1;
        default:
            return 0;
    }
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
    if (indexPath.section == 1) {
        if (indexPath.row < self.todolist.count) {
            TodoListTableViewCell* cell = [self dequeueReusableCellWithIdentifier:@"todoDetailCellIdentifier"];
            [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:50];
            Todo* todo = [self.todolist objectAtIndex:indexPath.row];
            cell.todoLabel.text = todo.subject;
            [cell setDelegate:self];
            return cell;
        } else {
            TodoDetailAddChildTodoCell* cell = [self dequeueReusableCellWithIdentifier:@"addChildTodoCellIdentifier"];
            [cell setDelegate:self];
            return cell;
        }
    }
    
    TodoListTableViewCell* cell = [self dequeueReusableCellWithIdentifier:@"todoDetailCellIdentifier"];
    cell.todoLabel.text = @"";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return nil;
        case 1:
            return @"child todo";
        case 2:
            return @"comment";
        default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.todolist.count) {
        return ;
    }
    if ([self.todoDetailTableViewDelegate respondsToSelector:@selector(cellSelect:)]) {
        [self.todoDetailTableViewDelegate cellSelect:(id)[self cellForRowAtIndexPath:indexPath]];
    }
}

#pragma marks TodoDetailAddChildTodoCellDelegate
-(void)childTodoAdd:(NSString *)text
{
    Todo* todo = [[Todo alloc] init];
    todo.parent_rowid = self.todo.rowId;
    todo.subject = text;
    [self.todolist addObject:todo];
    [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.todolist.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    [TodoLogic createNewTodo:todo finishCreate:^(id result) {
        [TodoLogic putTodoAtBottom:todo.rowId];
    }];
}

#pragma marks SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [self indexPathForCell:cell];
    Todo* todo = [self.todolist objectAtIndex:indexPath.row];
    [self.todolist removeObjectAtIndex:indexPath.row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [TodoLogic deleteTodo:todo.rowId];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

@end
