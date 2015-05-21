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

static const CGFloat flipAnimationSpeed = .3f;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *todolistTableView;

@property (weak, nonatomic) IBOutlet UIWeatherView *weatherView;

@property (weak, nonatomic) IBOutlet UIAddTodoView *addTodoView;

@property (nonatomic) NSArray* todolist;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.todolist = [TodoLogic queryDayTodoListWithDate:[NSDate date]];
    UISwipeGestureRecognizer* weatherSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leaveWeather:)];
    weatherSwipe.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    [self.weatherView addGestureRecognizer:weatherSwipe];
    
    UISwipeGestureRecognizer* addTodoSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leaveAddTodo:)];
    addTodoSwipe.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    [self.addTodoView addGestureRecognizer:addTodoSwipe];
}

-(void)leaveWeather:(UITapGestureRecognizer *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:flipAnimationSpeed];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.weatherView.transform = CGAffineTransformScale(self.weatherView.transform, 1.0, 0.01);
    self.addTodoView.transform = CGAffineTransformScale(self.addTodoView.transform, 1.0, 0.01);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(leaveWeatherFinish:)];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:flipAnimationSpeed];
    [UIView setAnimationDuration:flipAnimationSpeed];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.addTodoView.transform = CGAffineTransformScale(self.addTodoView.transform, 1.0, 100.0);
    self.weatherView.transform = CGAffineTransformScale(self.weatherView.transform, 1.0, 100.0);
    [UIView commitAnimations];
}

- (void)leaveWeatherFinish:(id)sender
{
    [[self.addTodoView superview] bringSubviewToFront:self.addTodoView];
    [self.addTodoView.addTodoTextField becomeFirstResponder];
}

-(void)leaveAddTodo:(UITapGestureRecognizer *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:flipAnimationSpeed];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.weatherView.transform = CGAffineTransformScale(self.weatherView.transform, 1.0, 0.01);
    self.addTodoView.transform = CGAffineTransformScale(self.addTodoView.transform, 1.0, 0.01);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(leaveAddTodoFinish:)];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:flipAnimationSpeed];
    [UIView setAnimationDuration:flipAnimationSpeed];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.weatherView.transform = CGAffineTransformScale(self.weatherView.transform, 1.0, 100.0);
    self.addTodoView.transform = CGAffineTransformScale(self.addTodoView.transform, 1.0, 100.0);
    [UIView commitAnimations];
}

- (void)leaveAddTodoFinish:(id)sender
{
    [[self.weatherView superview] bringSubviewToFront:self.weatherView];
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *todoIdentifier = @"todoIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todoIdentifier];
    cell.textLabel.text = [[self.todolist objectAtIndex:indexPath.row] subject];
    return cell;
}

@end
