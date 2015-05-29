//
//  TodoTableViewCell.h
//  todolist
//
//  Created by FanFamily on 15/5/29.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "FMMoveTableViewCell.h"

@class TodoTableViewCell;

@protocol TodoTableViewCellDelegate <NSObject>

@optional

- (void)todoRightDoubleSwipe:(TodoTableViewCell *)cell;
- (void)todoLeftSwipe:(TodoTableViewCell *)cell;

@end

@interface TodoTableViewCell : FMMoveTableViewCell

@property (nonatomic, weak) id<TodoTableViewCellDelegate> delegate;

@end
