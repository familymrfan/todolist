//
//  ViewController.m
//  todolist
//
//  Created by FanFamily on 15/4/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "ViewController.h"
#import "TodoLogic.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *todolistTableView;
@property (nonatomic) NSArray* todolist;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.todolist = [TodoLogic queryDayTodoListWithDate:[NSDate date]];
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

@end
