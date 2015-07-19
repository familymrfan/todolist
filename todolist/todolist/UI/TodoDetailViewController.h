//
//  TodoDetailViewController.h
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoDetailTableView.h"
#import "TodoDetailPathCollectionView.h"

@class Todo;
@interface TodoDetailViewController : UIViewController

@property (nonatomic) Todo* todo;
@property (weak, nonatomic) IBOutlet TodoDetailTableView *todoDetailTableView;
@property (weak, nonatomic) IBOutlet TodoDetailPathCollectionView *todoDetailCollectionView;

@end
