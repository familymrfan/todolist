//
//  UITodoDetailView.m
//  todolist
//
//  Created by FanFamily on 15/6/2.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "UITodoDetailView.h"
#import "TodoLogic.h"
#import "SZTextView.h"

static CGFloat kLeftSpace = 100.;

@interface UITodoDetailView () <UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tododetailViewToLeft;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet SZTextView *detailTextView;

@property (nonatomic, assign) CGFloat constant;
@property (nonatomic) Todo* todo;

@end

@implementation UITodoDetailView

- (void)awakeFromNib
{
    self.alpha = .8;
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTriger:)];
    [self addGestureRecognizer:pan];
    
    UISwipeGestureRecognizer* swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTriger:)];
    [self addGestureRecognizer:swip];
    
    [self.titleTextField setDelegate:self];
    [self.titleTextField addTarget:self action:@selector(titleTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.detailTextView.placeholder = @"备注";
    self.detailTextView.placeholderTextColor = [UIColor lightGrayColor];
    self.detailTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    [self.detailTextView setDelegate:self];
}

- (void)show
{
    self.tododetailViewToLeft.constant = kLeftSpace;
    [UIView animateWithDuration:.3f animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.todoDetailViewStatus = kTodoDetailViewShowStatus;
    }];
}

- (void)showWithTodoId:(NSNumber *)todoId
{
    Todo* todo = [TodoLogic queryTodoWithId:todoId];
    self.todo = todo;
    [self.titleTextField setText:todo.subject];
    if (todo.detail.length > 0) {
        [self.detailTextView setText:todo.detail];
    } else {
        [self.detailTextView setText:@""];
    }
    [self show];
}

- (void)hide
{
    [self.titleTextField resignFirstResponder];
    [self.detailTextView resignFirstResponder];
    self.tododetailViewToLeft.constant = self.superview.frame.size.width;
    [UIView animateWithDuration:.3f animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.todoDetailViewStatus = kTodoDetailViewHideStatus;
    }];
}

- (void)swipeTriger:(UISwipeGestureRecognizer *)gesture
{
    [self hide];
}

- (void)panTriger:(UIPanGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan) {
        self.constant = self.tododetailViewToLeft.constant;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.tododetailViewToLeft.constant > kLeftSpace + self.constant) {
            [self hide];
        } else {
            [self show];
        }
    } else {
        CGPoint p = [gesture translationInView:self];
        CGFloat constant = self.constant + p.x;
        if (constant < kLeftSpace) {
            return ;
        }
        self.tododetailViewToLeft.constant = constant;
        [self.superview layoutIfNeeded];
    }
}

- (void)titleTextFieldDidChange:(id)sender {
    self.todo.subject = self.titleTextField.text;
    [TodoLogic updateTodo:self.todo finish:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(todoSubjectChanged:todoId:)]) {
        [self.delegate todoSubjectChanged:self.todo.subject todoId:self.todo.rowId];
    }
}

- (IBAction)deleteTodo:(id)sender {
    [self hide];
    [TodoLogic deleteTodo:self.todo.rowId];
    if (self.delegate && [self.delegate respondsToSelector:@selector(todoDelete:)]) {
        [self.delegate todoDelete:self.todo.rowId];
    }
}

#pragma marks UITextViewDelegate method
- (void)textViewDidChange:(UITextView *)textView
{
    self.todo.detail = self.detailTextView.text;
    [TodoLogic updateTodo:self.todo finish:nil];
}

@end
