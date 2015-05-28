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

static const CGFloat kAnimationTodoSpeed = .3f;

@interface ViewController () <FMMoveTableViewDelegate, FMMoveTableViewDataSource, UIAddTodoViewDelegate, UITodoListViewDelegate>

@property (weak, nonatomic) IBOutlet UITodoListView *todolistTableView;

@property (weak, nonatomic) IBOutlet UIWeatherView *weatherView;

@property (weak, nonatomic) IBOutlet UIAddTodoView *addTodoView;

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
    [self.todolistTableView setTodoListViewDelegate:self];
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
    FMMoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todoIdentifier];
    /*cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];*/
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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

// 展开添加待办
- (void)expandAddTodo
{
    self.addTodoViewToTop.constant += self.weatherView.frame.size.height;
    [UIView animateWithDuration:kAnimationTodoSpeed animations:^{
        [self.addTodoView layoutIfNeeded];
    }];
    [self.addTodoView.addTodoTextField becomeFirstResponder];
    [self.weatherView.addTodoButton setTitle:@"-" forState:UIControlStateNormal];
}

// 收起待办
- (void)shrinkAddTodo
{
    self.addTodoViewToTop.constant = 0;
    [UIView animateWithDuration:kAnimationTodoSpeed animations:^{
        [self.addTodoView layoutIfNeeded];
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
-(void)touchInTodoListView
{
    if (![self isShrink]) {
        [self shrinkAddTodo];
    }
}

#pragma mark FMMoveTableViewDataSource
- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"from %ld -> to %ld", fromIndexPath.row, toIndexPath.row);
    Todo* todo = [self.todolist objectAtIndex:fromIndexPath.row];
    Todo* todoCopy = [todo deepCopy];
    [self.todolist insertObject:todoCopy atIndex:toIndexPath.row + 1];
    [self.todolist removeObject:todo];
    [self.todolistTableView reloadData];
    
    NSNumber* destId = nil;
    if (toIndexPath.row + 1 <= self.todolist.count -1) {
        Todo* todoDest = [self.todolist objectAtIndex:toIndexPath.row + 1];
        destId = todoDest.rowId;
    }
    
    [TodoLogic putOnAnotherTodoWithSrcTodoId:todoCopy.rowId withDestTodoId:destId finish:^(NSNumber* destTodoId) {
        [self.todolist replaceObjectAtIndex:[self.todolist indexOfObject:todoCopy] withObject:[TodoLogic queryTodoWithId:destTodoId]];
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
