//
//  ViewController.m
//  todolist
//
//  Created by FanFamily on 15/4/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "ViewController.h"
#import "TodoLogic.h"
#import "UIWeatherView.h"
#import "UIAddTodoView.h"

static const CGFloat kAnimationTodoSpeed = .3f;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAddTodoViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *todolistTableView;

@property (weak, nonatomic) IBOutlet UIWeatherView *weatherView;

@property (weak, nonatomic) IBOutlet UIAddTodoView *addTodoView;

@property (nonatomic) NSArray* todolist;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addTodoViewToTop;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.todolist = [TodoLogic queryDayTodoListWithDate:[NSDate date]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTodoListView:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.todolistTableView addGestureRecognizer:tapGestureRecognizer];
    
    [self.addTodoView setDelegate:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [self.todolist count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *todoIdentifier = @"todoIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todoIdentifier];
    cell.textLabel.text = [[self.todolist objectAtIndex:indexPath.row] subject];
    return cell;
}

// 展开添加待办
- (void)expandAddTodo
{
    self.addTodoViewToTop.constant += self.weatherView.frame.size.height;
    [UIView animateWithDuration:kAnimationTodoSpeed animations:^{
        [self.addTodoView layoutIfNeeded];
    }];
    [self.addTodoView.addTodoTextField becomeFirstResponder];
    [self.weatherView.addTodoButton setTitle:@"-" forState:UIControlStateNormal];
}

// 收起待办
- (void)shrinkAddTodo
{
    self.addTodoViewToTop.constant = 0;
    [UIView animateWithDuration:kAnimationTodoSpeed animations:^{
        [self.addTodoView layoutIfNeeded];
    }];
    [self.addTodoView.addTodoTextField resignFirstResponder];
    [self.weatherView.addTodoButton setTitle:@"+" forState:UIControlStateNormal];
}

- (BOOL)isShrink
{
    return [self.weatherView.addTodoButton.titleLabel.text isEqualToString:@"+"];
}

- (IBAction)addTodo:(id)sender {
    if ([self isShrink]) {
        [self expandAddTodo];
    } else {
        [self shrinkAddTodo];
    }
}

-(void)addTodoDone
{
    if (![self isShrink]) {
        [self shrinkAddTodo];
    }
}

-(void)tapTodoListView:(UITapGestureRecognizer*)tap{
    if (![self isShrink]) {
        [self shrinkAddTodo];
    }
}

@end
