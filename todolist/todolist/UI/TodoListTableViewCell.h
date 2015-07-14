//
//  TodoListTableViewCell.h
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class TodoListTableViewCell;
@protocol TodoListTableViewCellDelegate <NSObject>

@optional

- (void)todoDone:(TodoListTableViewCell *)cell;
- (void)todoNoDone:(TodoListTableViewCell *)cell;

@end

@interface TodoListTableViewCell : SWTableViewCell

@property (nonatomic, weak) id<TodoListTableViewCellDelegate> todoListCellDelegate;
@property (weak, nonatomic) IBOutlet UILabel *todoLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;

@end
