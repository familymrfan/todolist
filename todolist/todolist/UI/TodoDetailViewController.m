//
//  TodoDetailViewController.m
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoDetailViewController.h"
#import "TodoLogic.h"

@interface TodoDetailViewController () <TodoDetailTableViewDelegate>

@end

@implementation TodoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.todoDetailTableView.todo = self.todo;
    self.todoDetailTableView.todolist = [[TodoLogic queryTodoChildList:self.todo.rowId] mutableCopy];
    [self.todoDetailTableView setTodoDetailTableViewDelegate:self];
    self.todoDetailCollectionView.todoSubjectList = [[TodoLogic queryParentTodoList:self.todo.rowId] arrayByAddingObject:self.todo];
}

-(void)cellSelect:(TodoListTableViewCell *)cell
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    TodoDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"todoDetailViewControllerIdentity"];
    NSIndexPath* indexPath = [self.todoDetailTableView indexPathForCell:(id)cell];
    if (indexPath && indexPath.section == 1) {
        Todo* todo = [self.todoDetailTableView.todolist objectAtIndex:indexPath.row];
        if (todo) {
            vc.todo = todo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToMainView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
