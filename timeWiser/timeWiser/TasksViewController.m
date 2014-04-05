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

@interface TasksViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *colorArray;
}
@property (strong, nonatomic) IBOutlet UITableView *taskTable;
@property (strong, nonatomic) TaskCell *testCell;
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *details;
@property (strong, nonatomic) NSMutableArray *minutes;
@property (strong, nonatomic) NSMutableArray *hours;
@property (nonatomic) NSInteger numberOfItems;
@end

@implementation TasksViewController

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
    [self.taskTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    colorArray = [[NSMutableArray alloc] initWithObjects:[UIColor flatRedColor], [UIColor flatGreenColor], [UIColor flatBlueColor], [UIColor flatTealColor], [UIColor flatPurpleColor], [UIColor flatYellowColor], [UIColor flatGrayColor], nil];
    self.titles = [[NSMutableArray alloc] init];
    self.details = [[NSMutableArray alloc] init];
    self.minutes = [[NSMutableArray alloc] init];
    self.hours = [[NSMutableArray alloc] init];
    self.taskTable.backgroundColor = [UIColor flatWhiteColor];
    CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    self.numberOfItems = [objects count];
    if ([objects count] == 0)
    {
        NSLog(@"No Matches");
    }
    else
    {
        for (int i = 0; i < [objects count]; i++)
        {
            matches = objects[i];
            [self.titles addObject:[matches valueForKey:@"title"]];
            [self.details addObject:[matches valueForKey:@"details"]];
            [self.minutes addObject:[matches valueForKey:@"minutes"]];
            [self.hours addObject:[matches valueForKey:@"hours"]];
        }
    }
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (!self.testCell)
    {
        self.testCell = [self.taskTable dequeueReusableCellWithIdentifier:@"taskCell"];
    }
    
    //configure the cell
    self.testCell.titleLabel.text = [self.titles objectAtIndex:indexPath.row];
    self.testCell.detailLabel.text = [self.details objectAtIndex:indexPath.row];
    self.testCell.timeLabel.text = [NSString stringWithFormat:@"%@ : %@",[self.hours objectAtIndex:indexPath.row],[self.minutes objectAtIndex:indexPath.row]];
    //Layout the cell
    [self.testCell layoutIfNeeded];
    //Get the height for the cell
    CGFloat height = [self.testCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //Padding of 1 point for the seperator
    return height + 1;
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
    return self.numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCell *cell = [self.taskTable dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"];
    }
    cell.titleLabel.text = [self.titles objectAtIndex:indexPath.row];
    cell.detailLabel.text = [self.details objectAtIndex:indexPath.row];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ : %@",[self.hours objectAtIndex:indexPath.row],[self.minutes objectAtIndex:indexPath.row]];
    cell.timeLabel.backgroundColor = [UIColor flatWhiteColor];
    cell.detailLabel.backgroundColor = [UIColor flatWhiteColor];
    cell.titleLabel.backgroundColor = [UIColor flatWhiteColor];
    cell.backgroundColor = [UIColor flatWhiteColor];
    cell.colorView.backgroundColor = [colorArray objectAtIndex:indexPath.row];
    return cell;
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
