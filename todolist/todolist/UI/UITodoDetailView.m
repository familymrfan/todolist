//
//  UITodoDetailView.m
//  todolist
//
//  Created by FanFamily on 15/6/2.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "UITodoDetailView.h"

static CGFloat kLeftSpace = 100.;

@interface UITodoDetailView () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tododetailViewToLeft;
@property (nonatomic, assign) CGFloat constant;

@end

@implementation UITodoDetailView

- (void)awakeFromNib
{
    self.alpha = .8;
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTriger:)];
    [self addGestureRecognizer:pan];
    
    UISwipeGestureRecognizer* swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTriger:)];
    [self addGestureRecognizer:swip];
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

- (void)hide
{
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

@end
