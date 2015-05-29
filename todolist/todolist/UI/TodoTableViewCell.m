//
//  TodoTableViewCell.m
//  todolist
//
//  Created by FanFamily on 15/5/29.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "todoTableViewCell.h"
#import "UIErasureGestureRecognizer.h"

@interface TodoTableViewCell ()

@property (nonatomic) NSTimer* timerGesture;
@property (nonatomic, assign) NSInteger toRightSwipCount;

@end

@implementation TodoTableViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)initializer
{
    // 用于完成的手势
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTriger:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipe];
    
    // 用于恢复的手势
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTriger:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipe];
}

- (void)reportTodoDone
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(todoRightDoubleSwipe:)]) {
        self.timerGesture = nil;
        self.toRightSwipCount = 0;
        [self.delegate todoRightDoubleSwipe:self];
    }
}

- (void)reporttodoLeftSwipe
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(todoLeftSwipe:)]) {
        [self.delegate todoLeftSwipe:self];
    }
}

- (void)swipeTriger:(UISwipeGestureRecognizer *)gesture
{
    if ([gesture direction] == UISwipeGestureRecognizerDirectionRight) {
        self.toRightSwipCount++;
        if (self.timerGesture == nil) {
            self.timerGesture = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(swipeTimerTriger:) userInfo:nil repeats:NO];
        } else if (self.toRightSwipCount == 2) {
            [self reportTodoDone];
        }
    } else if ([gesture direction] == UISwipeGestureRecognizerDirectionLeft) {
        [self reporttodoLeftSwipe];
    }
}

- (void)swipeTimerTriger:(NSTimer *)timer
{
    self.timerGesture = nil;
    self.toRightSwipCount = 0;
}

@end
