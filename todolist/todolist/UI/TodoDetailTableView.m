//
//  TodoDetailTableView.m
//  todolist
//
//  Created by FanFamily on 15/7/16.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoDetailTableView.h"

@interface TodoDetailTableView () <UITableViewDataSource, UITableViewDelegate>

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
            return 10;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:@"todoDetailCellIdentifier"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"time plane";
        case 1:
            return @"child todo";
        case 2:
            return @"comment";
        default:
            return 0;
    }
}

@end
