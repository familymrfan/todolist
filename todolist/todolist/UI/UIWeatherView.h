//
//  UIWeatherView.h
//  todolist
//
//  Created by FanFamily on 15/5/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIWeatherViewDelegate <NSObject>

@optional

- (void)preDay:(NSDate *)date;
- (void)lastDay:(NSDate *)date;

@end

@interface UIWeatherView : UIView

@property (nonatomic, weak) id<UIWeatherViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIButton* addTodoButton;
@property (nonatomic, weak) IBOutlet UILabel* dateLabel;

- (void)refreshDate;

@end
