//
//  TodoListTableViewCell.m
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoListTableViewCell.h"

@implementation TodoListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setTodoDone:(id)sender {
    UIButton* btn = sender;
    if ([btn.currentTitle compare:@"no" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        if ([self.todoListCellDelegate respondsToSelector:@selector(todoDone:)]) {
            [self.todoListCellDelegate todoDone:self];
        }
    } else {
        if ([self.todoListCellDelegate respondsToSelector:@selector(todoNoDone:)]) {
            [self.todoListCellDelegate todoNoDone:self];
        }
    }
}
@end
