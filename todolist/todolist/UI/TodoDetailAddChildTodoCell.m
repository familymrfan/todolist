//
//  TodoDetailAddChildTodoCell.m
//  todolist
//
//  Created by FanFamily on 15/7/18.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoDetailAddChildTodoCell.h"

@implementation TodoDetailAddChildTodoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addChildTodo:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(childTodoAdd:)]) {
        [self.delegate childTodoAdd:self.childTodoTextField.text];
    }
}

@end
