//
//  TasksViewController.m
//  timeWiser
//
//  Created by Liu Zhe on 4/4/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "TasksViewController.h"
#import "TaskCell.h"
#import "CDAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+MLPFlatColors.h"
#import "M13Checkbox.h"

@interface TasksViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *colorArray;
}

@property (strong, nonatomic) TaskCell *testCell;
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *details;
@property (strong, nonatomic) NSMutableArray *minutes;
@property (strong, nonatomic) NSMutableArray *hours;
@property (nonatomic) NSInteger numberOfItems;
@property (nonatomic) BOOL hasNoTask;
@property (strong, nonatomic) NSMutableArray *objects;
@end

@implementation TasksViewController
@synthesize objects;
@synthesize hasNoTask;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self fetchContents];
    [self.taskTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self fetchContents];
    [self.taskTable reloadData];
}

- (void)fetchContents
{
    if (!self.titles)
    {
        self.titles = [[NSMutableArray alloc] init];
    }
    if (!self.details)
    {
        self.details = [[NSMutableArray alloc] init];
    }
    if (!self.minutes)
    {
        self.minutes = [[NSMutableArray alloc] init];
    }
    if (!self.hours)
    {
        self.hours = [[NSMutableArray alloc] init];
    }
    [self.titles removeAllObjects];
    [self.details removeAllObjects];
    [self.minutes removeAllObjects];
    [self.hours removeAllObjects];
    CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *isCompleted = [NSPredicate predicateWithFormat:@"isCompleted == NO"];
    [request setPredicate:isCompleted];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    NSManagedObject *matches = nil;
    NSError *error = nil;
    if (!objects)
    {
        objects = [[NSMutableArray alloc] init];
    }
    [objects removeAllObjects];
    [objects addObjectsFromArray:[context executeFetchRequest:request error:&error]];
    self.numberOfItems = [objects count];
    NSLog(@"number of tasks in data base is: %ld",[objects count]);
    if ([objects count] == 0)
    {
        NSLog(@"No Matches");
        hasNoTask = YES;
    }
    else
    {
        hasNoTask = NO;
        for (int i = 0; i < [objects count]; i++)
        {
            matches = objects[i];
            [self.titles addObject:[matches valueForKey:@"title"]];
            [self.details addObject:[matches valueForKey:@"details"]];
            [self.minutes addObject:[matches valueForKey:@"minutes"]];
            [self.hours addObject:[matches valueForKey:@"hours"]];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    colorArray = [[NSMutableArray alloc] initWithObjects:[UIColor flatRedColor], [UIColor flatGreenColor], [UIColor flatBlueColor], [UIColor flatTealColor], [UIColor flatPurpleColor], [UIColor flatYellowColor], [UIColor flatGrayColor], nil];
    self.taskTable.backgroundColor = [UIColor flatWhiteColor];
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fetchContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view cell height
//not complete!
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //calculate a height based on a cell
    if (!hasNoTask)
    {
    if (!self.testCell)
    {
        self.testCell = [self.taskTable dequeueReusableCellWithIdentifier:@"taskCell"];
    }
    
    //configure the cell
    self.testCell.titleLabel.text = [self.titles objectAtIndex:indexPath.row];
    self.testCell.detailLabel.text = [self.details objectAtIndex:indexPath.row];
    self.testCell.timeLabel.text = [NSString stringWithFormat:@"%@ Hr  %@ Mins",[self.hours objectAtIndex:indexPath.row],[self.minutes objectAtIndex:indexPath.row]];
    self.testCell.checkBox.checkState = M13CheckboxStateUnchecked;
    self.testCell.checkBox.strokeColor = [UIColor flatBlueColor];
    self.testCell.checkBox.checkColor = [UIColor flatBlueColor];
    //Layout the cell
    [self.testCell layoutIfNeeded];
    //Get the height for the cell
    CGFloat height = [self.testCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //Padding of 1 point for the seperator
    return height + 1;
    }
    return 95;
}

//load contents faster!
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (hasNoTask)
    {
        return 1;
    }
    else
    {
        return self.numberOfItems;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!hasNoTask)
    {
       TaskCell *cell = (TaskCell *)[self.taskTable dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
        // Configure the cell...
        if (!cell)
        {
            cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"];
        }
        cell.titleLabel.text = [self.titles objectAtIndex:indexPath.row];
        cell.detailLabel.text = [self.details objectAtIndex:indexPath.row];
        cell.titleLabel.textColor = [UIColor flatBlackColor];
        cell.detailLabel.textColor = [UIColor flatBlackColor];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ Hr  %@ Mins",[self.hours objectAtIndex:indexPath.row],[self.minutes objectAtIndex:indexPath.row]];
        cell.timeLabel.backgroundColor = [UIColor flatWhiteColor];
        cell.detailLabel.backgroundColor = [UIColor flatWhiteColor];
        cell.titleLabel.backgroundColor = [UIColor flatWhiteColor];
        cell.backgroundColor = [UIColor flatWhiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.colorView.backgroundColor = [colorArray objectAtIndex:indexPath.row % 7];
        cell.checkBox.checkState = M13CheckboxStateUnchecked;
        cell.checkBox.strokeColor = [UIColor flatBlueColor];
        cell.checkBox.checkColor = [UIColor flatBlueColor];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [self.taskTable dequeueReusableCellWithIdentifier:@"creator" forIndexPath:indexPath];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"creator"];
        }
        cell.textLabel.backgroundColor = [UIColor flatWhiteColor];
        cell.textLabel.textColor = [UIColor flatBlackColor];
        cell.backgroundColor = [UIColor flatWhiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.text = @"No Task Yet, Tap To Create";
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:16.0f];
        return  cell;
    }
    return nil;
}
- (IBAction)checkBoxTapped:(id)sender forEvent:(UIEvent *)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.taskTable];
    // Lookup the index path of the cell whose checkbox was modified.
    NSIndexPath *indexPath = [self.taskTable indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil)
    {
        [self completeTaskAtIndexPath:indexPath];
        NSLog(@"Did tapped at checkbox location %ld",indexPath.row);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (hasNoTask)
    {
        [self performSegueWithIdentifier:@"newTask" sender:nil];
    }
}

//this will not delete the task from the data base but will set the isCompleted attribute to YES which indicate the task is completed and will not be shown in the table view
- (void)completeTaskAtIndexPath:(NSIndexPath *)indexPath
{
    CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *tempTask = [objects objectAtIndex:indexPath.row];
    NSManagedObject *completeTask = [context objectWithID:tempTask.objectID];
    [completeTask setValue:[NSNumber numberWithBool:YES] forKey:@"isCompleted"];
    NSError *error = nil;
    [context save:&error];
    [self deleteRowAtIndexPath:indexPath];
}

//this will remove the specific task from the data base and delete from the tableview
- (void)removeObjectFromDataBaseAtIndexPath:(NSIndexPath *)indexPath
{
    CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:[objects objectAtIndex:indexPath.row]];
    NSError *error = nil;
    [context save:&error];
    [self deleteRowAtIndexPath:indexPath];
}

//delete a row at indexPath, does not necessarily delete from data base, will do a fetch request after deletion
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.numberOfItems = self.numberOfItems - 1;
    [self.taskTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self fetchContents];
    [self.taskTable reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
