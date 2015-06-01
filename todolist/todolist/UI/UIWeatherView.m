//
//  UIWeatherView.m
//  todolist
//
//  Created by FanFamily on 15/5/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "UIWeatherView.h"

@interface UIWeatherView ()

@property (nonatomic) NSDate* currentDate;
@property (nonatomic) NSDateFormatter* dateFormat;

@end

@implementation UIWeatherView

-(void)awakeFromNib
{
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTriger:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.dateLabel addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTriger:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.dateLabel addGestureRecognizer:swipeRight];
    
    self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateFormat:@"MM月dd日"];
    [self.dateLabel setTextColor:[UIColor whiteColor]];
}

- (void)refreshDate
{
    self.currentDate = [NSDate date];
    [self.dateLabel setText:[self.dateFormat stringFromDate:self.currentDate]];
}

- (void)swipeTriger:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(preDay:)]) {
            NSDate* preDay = [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:self.currentDate];
            self.currentDate = preDay;
            [self.dateLabel setText:[self.dateFormat stringFromDate:self.currentDate]];
            [self.delegate preDay:self.currentDate];;
        }
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(preDay:)]) {
            NSDate* lastDay = [[NSDate alloc] initWithTimeInterval:60*60*24 sinceDate:self.currentDate];
            self.currentDate = lastDay;
            [self.dateLabel setText:[self.dateFormat stringFromDate:self.currentDate]];
            [self.delegate lastDay:self.currentDate];;
        }
    }
}

@end
