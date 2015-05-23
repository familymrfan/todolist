//
//  UIAddTodoView.m
//  todolist
//
//  Created by FanFamily on 15/5/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "UIAddTodoView.h"

@interface UIAddTodoView () <UITextFieldDelegate>

@end

@implementation UIAddTodoView

-(void)awakeFromNib
{
    [self.addTodoTextField setDelegate:self];
    self.addTodoTextField.returnKeyType = UIReturnKeyDone;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate addTodoDone];
    return YES;
}

@end
