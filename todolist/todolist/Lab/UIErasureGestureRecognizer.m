//
//  UIErasureGestureRecognizer.m
//  todolist
//
//  Created by FanFamily on 15/5/29.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "UIErasureGestureRecognizer.h"
#import "UIKit/UIGestureRecognizerSubclass.h"

@interface UIErasureGestureRecognizer ()

@property (nonatomic, assign) CGPoint pointStart;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) NSInteger count; // 有效操作计数
@property (nonatomic) NSTimer* timer;

@end

@implementation UIErasureGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    self.pointStart = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint pointMove = [touch locationInView:self.view];
    CGFloat distance = pointMove.x - self.pointStart.x;
    
    NSLog(@"distance %f", distance);
    
    if (fabs(distance) < 20) {
        return ;
    }
    
    if (self.distance == 0) {
        self.distance = distance;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTriger:) userInfo:nil repeats:NO];
        self.count++;
    } else {
        // 小距离的移动不作为擦除动作
        if ((distance < 0 && self.distance > 0)
                || (distance > 0 && self.distance < 0)) {
                self.count++;
                self.distance = distance;
        }
    }
    
    NSLog(@"count %ld", self.count);
}

- (void)reset
{
    self.count = 0;
    self.timer = nil;
    self.distance = .0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.count >= 3) {
        [self setState:UIGestureRecognizerStateEnded];
    }
}

- (void)timerTriger:(NSTimer *)timer
{
    if (self.count < 3) {
        if (self.state == UIGestureRecognizerStatePossible) {
            [self setState:UIGestureRecognizerStateFailed];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStatePossible) {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

@end
