//
//  TodayViewController.m
//  timeWiser
//
//  Created by Liu Zhe on 3/31/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "TodayViewController.h"
#import "NSDate+MTDates.h"
#import "CDAppDelegate.h"

@interface TodayViewController ()
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *times;
@property (strong, nonatomic) NSMutableArray *objects;
//@property (strong, nonatomic) NSMutableArray *hours;
//@property (strong, nonatomic) NSMutableArray *minutes;
@end

@implementation TodayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self fetchContents];
}

- (void)fetchContents
{
    if (!_titles)
    {
        self.titles = [[NSMutableArray alloc] init];
    }
    if (!_times)
    {
        self.times = [[NSMutableArray alloc] init];
    }
    if (!_objects)
    {
        self.objects = [[NSMutableArray alloc] init];
    }
    NSDate *startOfToday = [NSDate mt_startOfToday];
    NSDate *endOfToday = [NSDate mt_endOfToday];
    [self.titles removeAllObjects];
    [self.times removeAllObjects];
    [self.objects removeAllObjects];
    CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *todayTasks = [NSPredicate predicateWithFormat:@"((completeDate >= %@) AND (completeDate <= %@) && completeDate != nil)",startOfToday, endOfToday];
    [request setPredicate:todayTasks];
    NSError *error = nil;
    [self.objects addObjectsFromArray:[context executeFetchRequest:request error:&error]];
    NSManagedObject *match = nil;
    //then do the calculation of time and put things in array
    if ([self.objects count] == 0)
    {
        
    }
    else
    {
        //in here you should setup the bars or dots in the chart
        
        //put things into places
        for (int i = 0; i < [self.objects count]; i++)
        {
            match = self.objects[i];
            [self.titles addObject:[match valueForKey:@"title"]];
            int minutes = [[match valueForKey:@"minutes"] intValue];
            int hours = [[match valueForKey:@"hours"] intValue];
            NSNumber *totalMinutes = [NSNumber numberWithInt:minutes + hours * 60];
            [self.times addObject:totalMinutes];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchContents];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
