//
//  TodoDetailPathCollectionView.m
//  todolist
//
//  Created by FanFamily on 15/7/18.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoDetailPathCollectionView.h"
#import "Todo.h"
#import "TodoDetailPathCollectionViewCell.h"

@interface TodoDetailPathCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation TodoDetailPathCollectionView

-(void)awakeFromNib
{
    [self setDelegate:self];
    [self setDataSource:self];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.todoSubjectList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TodoDetailPathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TodoDetailPathCellIdentifier" forIndexPath:indexPath];
    id todo = [self.todoSubjectList objectAtIndex:indexPath.row];
    [cell.pathText setText:[NSString stringWithFormat:@"%@ >", [todo subject]]];
    return cell;
    
}

@end
