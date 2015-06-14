//
//  ViewController.m
//  todolist
//
//  Created by FanFamily on 15/4/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "ViewController.h"   
#import "TodoLogic.h"
#import "TodoListTableViewCell.h"

static const NSInteger kLeftlistSpace = 20;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *todolistTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todoTableViewToLeft;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_todolistTableView setDataSource:self];
    [_todolistTableView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoListTableViewCell* cell = [_todolistTableView dequeueReusableCellWithIdentifier:@"todoCellIdentifier"];
    [cell.todoLabel setText:@"今天去买菜，一斤土豆，一斤白菜 ..."];
    return cell;
}

#pragma marks UITableViewDelegate method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* todoDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"todoDetailViewControllerIdentity"];
    [self.navigationController pushViewController:todoDetailViewController animated:YES];
}

- (IBAction)leftListSwitch:(id)sender {
    if (_todoTableViewToLeft.constant == kLeftlistSpace) {
        _todoTableViewToLeft.constant = 0;
    } else {
        _todoTableViewToLeft.constant = kLeftlistSpace;
    }
    [UIView animateWithDuration:.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
