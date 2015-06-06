//
//  ViewController.m
//  todolist
//
//  Created by FanFamily on 15/4/19.
//  Copyright (c) 2015年 FanFamily. All rights reserved.
//

#import "ViewController.h"
#import "TodoLogic.h"
#import "UIWeatherView.h"
#import "UIAddTodoView.h"
#import "FMMoveTableViewCell.h"
#import "UITodoListView.h"
#import "TodoTableViewCell.h"
#import "UITodoDetailView.h"

static const CGFloat kAnimationTodoSpeed = .3f;

@interface ViewController () <UITodoListViewDelegate, FMMoveTableViewDataSource, UIAddTodoViewDelegate, TodoTableViewCellDelegate, UIWeatherViewDelegate, UITodoDetailViewDelegate>

@property (weak, nonatomic) IBOutlet UITodoListView *todolistTableView;

@property (weak, nonatomic) IBOutlet UIWeatherView *weatherView;

@property (weak, nonatomic) IBOutlet UIAddTodoView *addTodoView;

@property (weak, nonatomic) IBOutlet UITodoDetailView *tododetailView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tododetailViewToLeft;

@property (nonatomic) NSMutableArray* todolist;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addTodoViewToTop;

@property (nonatomic) NSNumber* baseLine;

@property (nonatomic) NSMutableArray* cellsNotOnCenterStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseLine = @1;
    self.cellsNotOnCenterStatus = [NSMutableArray array];
    self.todolist = [NSMutableArray arrayWithArray:[TodoLogic queryDayTodoListWithDate:[NSDate date]]];
    [self.addTodoView setDelegate:self];
    [self.weatherView setDelegate:self];
    [self.todolistTableView setTodoListViewDelegate:self];
    self.tododetailViewToLeft.constant = self.view.frame.size.width;
    [self.tododetailView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.weatherView refreshDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [self.todolist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

/*- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                title:@"Done"];
    return leftUtilityButtons;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    return rightUtilityButtons;
}*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *todoIdentifier = @"todoIdentifier";
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todoIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    /*cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];*/
    [cell setDelegate:self];
    if ([self.todolistTableView indexPathIsMovingIndexPath:indexPath]) {
        [cell prepareForMove];
    } else {
        if ([[[self.todolist objectAtIndex:indexPath.row] status] isEqualToNumber:@(kTodoStatusDone)]) {
            [cell.textLabel setTextColor:[UIColor grayColor]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.todolist objectAtIndex:indexPath.row] subject]];
        } else {
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@", indexPath.row + self.baseLine.integerValue, [[self.todolist objectAtIndex:indexPath.row] subject]];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tododetailView.todoDetailViewStatus == kTodoDetailViewHideStatus) {
        [self.tododetailView showWithTodoId:[[self.todolist objectAtIndex:indexPath.row] rowId]];
    }
}

// 展开添加待办
- (void)expandAddTodo
{
    self.addTodoViewToTop.constant += self.weatherView.frame.size.height;
    [UIView animateWithDuration:kAnimationTodoSpeed animations:^{
        [self.view layoutIfNeeded];
        [self.addTodoView.addTodoTextField becomeFirstResponder];
    }];
    [self.weatherView.addTodoButton setTitle:@"-" forState:UIControlStateNormal];
    [self.tododetailView hide];
}

// 收起待办
- (void)shrinkAddTodo
{
    self.addTodoViewToTop.constant = 0;
    [UIView animateWithDuration:kAnimationTodoSpeed animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.addTodoView.addTodoTextField resignFirstResponder];
    [self.weatherView.addTodoButton setTitle:@"+" forState:UIControlStateNormal];
}

- (BOOL)isShrink
{
    return [self.weatherView.addTodoButton.titleLabel.text isEqualToString:@"+"];
}

- (IBAction)addTodo:(id)sender {
    if ([self isShrink]) {
        [self expandAddTodo];
    } else {
        [self shrinkAddTodo];
    }
}

- (void)addTodoDone
{
    if (![self isShrink]) {
        self.addTodoViewToTop.constant = 0;
        [self.addTodoView.addTodoTextField resignFirstResponder];
        [self.weatherView.addTodoButton setTitle:@"+" forState:UIControlStateNormal];
        [UIView animateWithDuration:kAnimationTodoSpeed animations:^{
            [self.addTodoView layoutIfNeeded];
        } completion:^(BOOL finished) {
            Todo* todo = [[Todo alloc] init];
            todo.subject = self.addTodoView.addTodoTextField.text;
            [self.addTodoView.addTodoTextField setText:@""];
            self.baseLine = @2;
            [self.todolistTableView reloadData];
            self.baseLine = @1;
            [self.todolist insertObject:todo atIndex:0];
            [self.todolistTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [TodoLogic createNewTodo:todo finishCreate:nil];
        }];
    }
}

#pragma mark todoListViewDelegate
-(BOOL)touchInTodoListView:(TodoTableViewCell *)cell
{
    [self.tododetailView hide];
    if (![self isShrink]) {
        [self shrinkAddTodo];
        return NO;
    }
    return YES;
}

#pragma mark FMMoveTableViewDataSource
- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"from %ld -> to %ld", fromIndexPath.row, toIndexPath.row);
    NSUInteger toindex = toIndexPath.row;
    if (fromIndexPath.row < toIndexPath.row) {
        toindex += 1;
    }
    Todo* todo = [self.todolist objectAtIndex:fromIndexPath.row];
    Todo* todoCopy = [todo deepCopy];
    [self.todolist insertObject:todoCopy atIndex:toindex];
    [self.todolist removeObject:todo];
    [self.todolistTableView reloadData];
    
    NSNumber* destId = nil;
    if (toIndexPath.row + 1 <= self.todolist.count -1) {
        Todo* todoDest = [self.todolist objectAtIndex:toindex];
        destId = todoDest.rowId;
    }
    
    [TodoLogic putOnAnotherTodoWithSrcTodoId:todoCopy.rowId withDestTodoId:destId finish:^(NSNumber* destTodoId) {
        [self.todolist replaceObjectAtIndex:[self.todolist indexOfObject:todoCopy] withObject:[TodoLogic queryTodoWithId:destTodoId]];
    }];
}

#pragma mark TodoTableViewCellDelegate
- (void)todoRightSwipe:(TodoTableViewCell *)cell
{
    NSIndexPath* cellIndexPath = [self.todolistTableView indexPathForCell:cell];
    if (cellIndexPath) {
        Todo* todo = [self.todolist objectAtIndex:cellIndexPath.row];
        if (todo.status.integerValue == kTodoStatusNoDo) {
            todo.status = @(kTodoStatusDone);
            [TodoLogic updateTodo:todo finish:nil];
            [self.todolist removeObject:todo];
            [self.todolist addObject:todo];
            [self.todolistTableView reloadData];
            [self.todolistTableView moveRowAtIndexPath:cellIndexPath toIndexPath:[NSIndexPath indexPathForItem:self.todolist.count - 1  inSection:0]];
            [TodoLogic putOnAnotherTodoWithSrcTodoId:todo.rowId withDestTodoId:nil finish:^(NSNumber* destTodoId) {
                [self.todolist removeObject:todo];
                [self.todolist addObject:[TodoLogic queryTodoWithId:destTodoId]];
            }];
        }
    }
}

- (void)todoLeftSwipe:(TodoTableViewCell *)cell
{
    NSIndexPath* cellIndexPath = [self.todolistTableView indexPathForCell:cell];
    if (cellIndexPath) {
        Todo* todo = [self.todolist objectAtIndex:cellIndexPath.row];
        if (todo.status.integerValue == kTodoStatusDone) {
            todo.status = @(kTodoStatusNoDo);
            [TodoLogic updateTodo:todo finish:nil];
            [self.todolist removeObject:todo];
            [self.todolist insertObject:todo atIndex:0];
            [self.todolistTableView reloadData];
            [self.todolistTableView moveRowAtIndexPath:cellIndexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            [TodoLogic putOnAnotherTodoWithSrcTodoId:todo.rowId withDestTodoId:nil finish:^(NSNumber* destTodoId) {
                [self.todolist removeObject:todo];
                [self.todolist insertObject:[TodoLogic queryTodoWithId:destTodoId] atIndex:0];
            }];
        }
    }
}

#pragma mark UIWeatherViewDelegate
- (void)preDay:(NSDate *)date
{
    self.todolist = [NSMutableArray arrayWithArray:[TodoLogic queryDayTodoListWithDate:date]];
    [self.todolistTableView reloadData];
}

-(void)lastDay:(NSDate *)date
{
    self.todolist = [NSMutableArray arrayWithArray:[TodoLogic queryDayTodoListWithDate:date]];
    [self.todolistTableView reloadData];
}

#pragma marks TodoDetailViewDelegate method
-(void)todoSubjectChanged:(NSString *)subject todoId:(NSNumber *)todoId
{
    [self.todolist enumerateObjectsUsingBlock:^(Todo* todo, NSUInteger idx, BOOL *stop) {
        if ([todo.rowId isEqualToNumber:todoId]) {
            todo.subject = subject;
            [self.todolistTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            return ;
        }
    }];
}

-(void)todoDelete:(NSNumber *)todoId
{
    [self.todolist enumerateObjectsUsingBlock:^(Todo* todo, NSUInteger idx, BOOL *stop) {
        if ([todo.rowId isEqualToNumber:todoId]) {
            [self.todolist removeObject:todo];
            [self.todolistTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]  withRowAnimation:UITableViewRowAnimationAutomatic];
            return ;
        }
    }];
}

#pragma mark SWTableViewCellDelegate
/*-(void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    if (state != kCellStateCenter) {
        [self.cellsNotOnCenterStatus enumerateObjectsUsingBlock:^(SWTableViewCell* obj, NSUInteger idx, BOOL *stop) {
            if (obj == cell) {
                return;
            }
            [obj hideUtilityButtonsAnimated:YES];
        }];
        [self.cellsNotOnCenterStatus removeAllObjects];
        [self.cellsNotOnCenterStatus addObject:cell];
    }
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0) {
        NSIndexPath* cellIndexPath = [self.todolistTableView indexPathForCell:cell];
        if (cellIndexPath) {
            Todo* todo = [self.todolist objectAtIndex:cellIndexPath.row];
            todo.status = @(kTodoStatusDone);
            [TodoLogic updateTodo:todo finish:nil];
            [self.todolist removeObject:todo];
            [self.todolist addObject:todo];
            [self.todolistTableView reloadData];
            [cell hideUtilityButtonsAnimated:NO];
            [self.todolistTableView moveRowAtIndexPath:cellIndexPath toIndexPath:[NSIndexPath indexPathForItem:self.todolist.count - 1  inSection:0]];
            [TodoLogic putOnAnotherTodoWithSrcTodoId:todo.rowId withDestTodoId:nil finish:^(NSNumber* destTodoId) {
                [self.todolist removeObject:todo];
                [self.todolist addObject:[TodoLogic queryTodoWithId:destTodoId]];
            }];
        }
    }
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0) {
        NSIndexPath* cellIndexPath = [self.todolistTableView indexPathForCell:cell];
        if (cellIndexPath) {
            Todo* todo = [self.todolist objectAtIndex:cellIndexPath.row];
            [self.todolist removeObject:todo];
            [self.todolistTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndexPath.row inSection:0]]withRowAnimation:UITableViewRowAnimationMiddle];
            [TodoLogic deleteTodo:todo.rowId];
        }
    }
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    if (state == kCellStateLeft) {
        NSIndexPath* cellIndexPath = [self.todolistTableView indexPathForCell:cell];
        if (cellIndexPath) {
            Todo* todo = [self.todolist objectAtIndex:cellIndexPath.row];
            if (todo.status.integerValue == kTodoStatusDone) {
                return NO;
            }
        }
    }
    return YES;
}*/

@end
