//
//  TodoDetailViewController.m
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoDetailViewController.h"

@interface TodoDetailViewController ()

@end

@implementation TodoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToMainView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
