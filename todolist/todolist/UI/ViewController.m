//
//  ViewController.m
//  todolist
//
//  Created by FanFamily on 15/4/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "ViewController.h"   
#import "TodoLogic.h"
#import "TodoListTableView.h"
#import "TodoListTableViewCell.h"

static const NSInteger kLeftlistSpace = 50;

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TodoListTableView *todolistTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todoTableViewToLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fackNavigationBarToLeft;
@property (weak, nonatomic) IBOutlet UITextField *addTodoTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.addTodoTextField setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftListSwitch:(id)sender {
    if (_todoTableViewToLeft.constant == kLeftlistSpace) {
        _todoTableViewToLeft.constant = 0;
    } else {
        _todoTableViewToLeft.constant = kLeftlistSpace;
    }
    if (_fackNavigationBarToLeft.constant == kLeftlistSpace) {
        _fackNavigationBarToLeft.constant = 0;
    } else {
        _fackNavigationBarToLeft.constant = kLeftlistSpace;
    }
    [UIView animateWithDuration:.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    Todo* todo = [[Todo alloc] init];
    todo.subject = self.addTodoTextField.text;
    [self.todolistTableView addTodo:todo];
    return YES;
}

@end
