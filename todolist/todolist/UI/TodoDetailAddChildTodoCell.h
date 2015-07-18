//
//  TodoDetailAddChildTodoCell.h
//  todolist
//
//  Created by FanFamily on 15/7/18.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TodoDetailAddChildTodoCellDelegate <NSObject>

- (void)childTodoAdd:(NSString *)text;

@end

@interface TodoDetailAddChildTodoCell : UITableViewCell

@property (nonatomic, weak) id<TodoDetailAddChildTodoCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *childTodoTextField;


@end
