//
//  TodoListTableView.m
//  todolist
//
//  Created by FanFamily on 15/6/14.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "TodoListTableView.h"
#import "TodoLogic.h"
#import "TodoListTableViewCell.h"
#import "QueueManager.h"

@interface TodoListTableView () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, TodoListTableViewCellDelegate>

@property (nonatomic) NSMutableArray* todoList;
@property (nonatomic) TodoListTableViewCell* cellRightStatus;
@property (nonatomic) UIView* snapsHotView;
@property (nonatomic) NSIndexPath* sourceIndexPath;
@property (nonatomic) UILongPressGestureRecognizer* movingGestureRecognizer;

@property (nonatomic, strong) NSTimer *autoscrollTimer;
@property (nonatomic, assign) NSInteger autoscrollDistance;
@property (nonatomic, assign) NSInteger autoscrollThreshold;

@end

@implementation TodoListTableView

-(void)awakeFromNib
{
    self.todoList = [NSMutableArray arrayWithArray:[TodoLogic queryDayTodoList]];
    [self setDelegate:self];
    [self setDataSource:self];
    
    UILongPressGestureRecognizer *movingGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];[self addGestureRecognizer:movingGestureRecognizer];
    self.movingGestureRecognizer = movingGestureRecognizer;
}

- (void)addTodo:(Todo *)todo
{
    [TodoLogic createNewTodo:todo finishCreate:^(id result) {
        [QueueManager asyncDoWorkBlockInMainQueue:^(id result, BOOL isCancel, finishWorkBlock finishBlock) {
            [self.todoList insertObject:todo atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }];
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

- (void)moveRowToLocation:(CGPoint)location withIndexPath:(NSIndexPath *)indexPath
{
    CGPoint center = self.snapsHotView.center;
    center.y = location.y;
    self.snapsHotView.center = center;
    
    if (indexPath && ![indexPath isEqual:self.sourceIndexPath]) {
        NSString* priority = nil;
        Todo* destTodo = [self.todoList objectAtIndex:indexPath.row];
        priority = destTodo.priority;
        Todo* srcTodo = [self.todoList objectAtIndex:self.sourceIndexPath.row];
        destTodo.priority = srcTodo.priority;
        srcTodo.priority = priority;
        [TodoLogic updateTodo:srcTodo finish:nil];
        [TodoLogic updateTodo:destTodo finish:nil];
        [self.todoList exchangeObjectAtIndex:indexPath.row withObjectAtIndex:self.sourceIndexPath.row];
    }
    
    [self moveRowAtIndexPath:self.sourceIndexPath toIndexPath:indexPath];
    self.sourceIndexPath = indexPath;
    [self cellForRowAtIndexPath:self.sourceIndexPath].hidden = YES;
}

- (void)longPressGestureRecognized:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
    
    Todo* todo = [self.todoList objectAtIndex:indexPath.row];
    if (state == UIGestureRecognizerStateBegan && todo.status.integerValue == kTodoStatusDone) {
        return ;
    } else if (state == UIGestureRecognizerStateChanged && todo.status.integerValue == kTodoStatusDone) {
        indexPath = nil;
    }
    if (indexPath == nil) {
        indexPath = self.sourceIndexPath;
    }
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
            {
                self.sourceIndexPath = indexPath;
                UITableViewCell* cell = [self cellForRowAtIndexPath:indexPath];
                self.snapsHotView = [self customSnapshotFromView:cell];
                __block CGPoint center = cell.center;
                self.snapsHotView.center = center;
                self.snapsHotView.alpha = 0.0;
                [self addSubview:self.snapsHotView];
                
                [self prepareAutoscrollForSnapshot];
                
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    self.snapsHotView.center = center;
                    self.snapsHotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    self.snapsHotView.alpha = 0.98;
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        case UIGestureRecognizerStateChanged:
            {
                [self moveRowToLocation:location withIndexPath:indexPath];
                [self maybeAutoscroll];
                
                if (![self isAutoscrolling]) {
                    [self moveRowToLocation:location withIndexPath:indexPath];
                }
            }
            break;
        default:
            {
                [self stopAutoscrolling];
                // Clean up.
                UITableViewCell *cell = [self cellForRowAtIndexPath:self.sourceIndexPath];
                cell.hidden = NO;
                cell.alpha = 0.0;
                [UIView animateWithDuration:0.25 animations:^{
                    self.snapsHotView.center = cell.center;
                    self.snapsHotView.transform = CGAffineTransformIdentity;
                    self.snapsHotView.alpha = 0.0;
                    // Undo fade out.
                    cell.alpha = 1.0;
                } completion:^(BOOL finished) {
                    cell.hidden = NO;
                    self.sourceIndexPath = nil;
                    [self.snapsHotView removeFromSuperview];
                    self.snapsHotView = nil;
                }];
            }
            break;
    }
}

#pragma marks UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todoList.count;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Del"];
    
    return rightUtilityButtons;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoListTableViewCell* cell = [self dequeueReusableCellWithIdentifier:@"todoCellIdentifier"];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:50];
    [cell setDelegate:self];
    [cell setTodoListCellDelegate:self];
    Todo* todo = [self.todoList objectAtIndex:indexPath.row];
    if (todo.subject) {
        [cell.todoLabel setText:todo.subject];
    }
    if (todo.status.integerValue == kTodoStatusDone) {
        [cell.buttonDone setTitle:@"Yes" forState:UIControlStateNormal];
        [cell.todoLabel setTextColor:[UIColor lightGrayColor]];
    } else {
        [cell.buttonDone setTitle:@"No" forState:UIControlStateNormal];
        [cell.todoLabel setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}

#pragma marks UITableViewDelegate method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UIViewController* todoDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"todoDetailViewControllerIdentity"];
    //[self.superview.navigationController pushViewController:todoDetailViewController animated:YES];
}

#pragma marks SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [self indexPathForCell:cell];
    Todo* todo = [self.todoList objectAtIndex:indexPath.row];
    [self.todoList removeObjectAtIndex:indexPath.row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [TodoLogic deleteTodo:todo.rowId];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

#pragma mark - Autoscrolling

- (void)prepareAutoscrollForSnapshot
{
    self.autoscrollThreshold = CGRectGetHeight(self.snapsHotView.frame) * 0.6;
    self.autoscrollDistance = 0;
}


- (void)maybeAutoscroll
{
    [self determineAutoscrollDistanceForSnapShot];
    
    if (self.autoscrollDistance == 0)
    {
        [self.autoscrollTimer invalidate];
        self.autoscrollTimer = nil;
    }
    else if (self.autoscrollTimer == nil)
    {
        self.autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0) target:self selector:@selector(autoscrollTimerFired:) userInfo:nil repeats:YES];
    }
}


- (void)determineAutoscrollDistanceForSnapShot
{
    self.autoscrollDistance = 0;
    
    // Check for autoscrolling
    // 1. The content size is bigger than the frame's
    // 2. The snap shot is still inside the table view's bounds
    if ([self canScroll] && CGRectIntersectsRect(self.snapsHotView.frame, self.bounds))
    {
        CGPoint touchLocation = [self.movingGestureRecognizer locationInView:self];
        
        CGFloat distanceToTopEdge = touchLocation.y - CGRectGetMinY(self.bounds);
        CGFloat distanceToBottomEdge = CGRectGetMaxY(self.bounds) - touchLocation.y;
        
        if (distanceToTopEdge < self.autoscrollThreshold)
        {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceToTopEdge] * -1;
        }
        else if (distanceToBottomEdge < self.autoscrollThreshold)
        {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceToBottomEdge];
        }
    }
}


- (CGFloat)autoscrollDistanceForProximityToEdge:(CGFloat)proximity
{
    return ceilf((self.autoscrollThreshold - proximity) / 5.0);
}


- (void)autoscrollTimerFired:(NSTimer *)timer
{
    [self legalizeAutoscrollDistance];
    
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y += self.autoscrollDistance;
    self.contentOffset = contentOffset;
    
    CGRect frame = self.snapsHotView.frame;
    frame.origin.y += self.autoscrollDistance;
    self.snapsHotView.frame = frame;
    
    CGPoint location = [self.movingGestureRecognizer locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
    if (indexPath == nil) {
        indexPath = self.sourceIndexPath;
    }
    [self moveRowToLocation:location withIndexPath:indexPath];
}


- (void)legalizeAutoscrollDistance
{
    CGFloat minimumLegalDistance = self.contentOffset.y * -1.0;
    CGFloat maximumLegalDistance = self.contentSize.height - (CGRectGetHeight(self.frame) + self.contentOffset.y);
    self.autoscrollDistance = MAX(self.autoscrollDistance, minimumLegalDistance);
    self.autoscrollDistance = MIN(self.autoscrollDistance, maximumLegalDistance);
}


- (void)stopAutoscrolling
{
    self.autoscrollDistance = 0.0;
    [self.autoscrollTimer invalidate];
    self.autoscrollTimer = nil;
}


- (BOOL)isAutoscrolling
{
    return (self.autoscrollDistance != 0);
}


- (BOOL)canScroll
{
    return (CGRectGetHeight(self.frame) < self.contentSize.height);
}

#pragma marks todoListCellDelegate

-(void)todoDone:(TodoListTableViewCell *)cell
{
    NSIndexPath* indexPath = [self indexPathForCell:cell];
    Todo* todo = [self.todoList objectAtIndex:indexPath.row];
    [TodoLogic putTodoAtBottom:todo.rowId];
    todo.status = @(kTodoStatusDone);
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [TodoLogic updateTodo:todo finish:nil];
    
    [self.todoList removeObject:todo];
    [self.todoList addObject:todo];
    
    
    [self moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.todoList.count-1 inSection:0]];
}

-(void)todoNoDone:(TodoListTableViewCell *)cell
{
    NSIndexPath* indexPath = [self indexPathForCell:cell];
    Todo* todo = [self.todoList objectAtIndex:indexPath.row];
    [TodoLogic putTodoAtTop:todo.rowId];
    todo.status = @(kTodoStatusNoDo);
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [TodoLogic updateTodo:todo finish:nil];
    [self.todoList removeObject:todo];
    [self.todoList insertObject:todo atIndex:0];
    
    
    [self moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end
