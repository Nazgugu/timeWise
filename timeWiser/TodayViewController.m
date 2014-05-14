//
//  TodayViewController.m
//  timeWiser
//
//  Created by Liu Zhe on 3/31/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "TodayViewController.h"
#import "CDAppDelegate.h"
#import "UIColor+MLPFlatColors.h"
#import "NSDate+MTDates.h"
#import "PNChart.h"


@interface TodayViewController ()<PNChartDelegate>
{
    NSArray *colorArray;
}
@property (weak, nonatomic) IBOutlet UIButton *previousPageButton;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *times;
@property (weak, nonatomic) IBOutlet PNBarChart *TaskChart;
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSMutableArray *colors;
@property (strong, nonatomic) NSMutableArray *showingTitles;
@property (strong, nonatomic) NSMutableArray *showingTime;
@property (nonatomic) NSUInteger currentPageNumber;
@property (nonatomic) NSUInteger totalPageNumber;
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

- (IBAction)previousPage:(id)sender {
    NSLog(@"go back");
    self.currentPageNumber -= 1;
    if (self.currentPageNumber < 1)
    {
        self.currentPageNumber = 1;
        return;
    }
    //implement this to get the correct tasks to show on the page
    [self updateChartWithPage:self.currentPageNumber];
}

- (IBAction)nextPage:(id)sender {
    NSLog(@"go next");
    self.currentPageNumber += 1;
    if (self.currentPageNumber > self.totalPageNumber)
    {
        self.currentPageNumber = self.totalPageNumber;
        return;
    }
    [self updateChartWithPage:self.currentPageNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"view will appear is called");
    [super viewWillAppear:animated];
    [self fetchContents];
    [self updateChartWithPage:1];
}

- (void)loadView
{
    //NSLog(@"load view is called");
    [super loadView];
    //[self fetchContents];
    self.TaskChart.backgroundColor = [UIColor clearColor];
    self.TaskChart.barBackgroundColor = PNLightGrey;;
}

- (void)updateChartWithPage:(NSUInteger)pageNumber
{
    self.TaskChart.showLabel = YES;
    
    //NSLog(@"times = %@",self.times);
    //NSLog(@"tasks are: %@",self.titles);
    if (!_colors)
    {
        _colors = [[NSMutableArray alloc] init];
    }
    if (!_showingTime)
    {
        _showingTime = [[NSMutableArray alloc] init];
    }
    if (!_showingTitles)
    {
        _showingTitles = [[NSMutableArray alloc] init];
    }
    [self.colors removeAllObjects];
    [self.showingTitles removeAllObjects];
    [self.showingTime removeAllObjects];
    int index;
    NSRange range;
    if ([self.objects count] < 7)
    {
            [self.showingTitles addObjectsFromArray:self.titles];
            [self.showingTime addObjectsFromArray:self.times];
    }
    else
    {
        NSUInteger startingLocation = (pageNumber - 1) * 7;
        NSUInteger endingLocation = startingLocation + 6;
        range.location = startingLocation;
        if ((startingLocation + endingLocation) > [self.objects count])
        {
            range.length = [self.objects count] % 7;
        }
        else
        {
            range.length = 7;
        }
        [self.showingTitles addObjectsFromArray:[self.titles subarrayWithRange:range]];
        [self.showingTime addObjectsFromArray:[self.times subarrayWithRange:range]];
    }
    for (int i = 0; i < [self.showingTitles count]; i++)
    {
        index = i % 7;
        [self.colors addObject:[colorArray objectAtIndex:index]];
    }
    [UIView transitionWithView:self.TaskChart
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.TaskChart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    } completion:^(BOOL finished){
                        [self.TaskChart setStrokeColors:self.colors];
                        [self.TaskChart setXLabels:self.showingTitles];
                        [self.TaskChart setTimeLabel:self.showingTime];
                        [self.TaskChart setYValues:self.showingTime];
                        [self.TaskChart strokeChart];
                    }];
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"view did load is called");
    //[self fetchContents];
    colorArray = [[NSArray alloc] initWithObjects:[UIColor flatRedColor], [UIColor flatGreenColor], [UIColor flatBlueColor], [UIColor flatYellowColor], [UIColor flatPurpleColor], [UIColor flatTealColor], [UIColor flatGrayColor], nil];
    self.TaskChart.delegate = self;
    //[self updateChart];
}

//barChart Delegate method
#pragma mark = PNChart delegate
- (void)userClickedOnBarCharIndex:(NSInteger)barIndex
{
    NSLog(@"Click on bar %@", @(barIndex));
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
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
        //NSLog(@"No task done yet");
        self.previousPageButton.enabled = NO;
        self.nextPageButton.enabled = NO;
        self.totalPageNumber = 1;
        self.currentPageNumber = 1;
    }
    else
    {
        //in here you should setup the bars or dots in the chart
        //NSLog(@"I have done some tasks");
        //put things into places
        if ([self.objects count] > 7)
        {
            self.previousPageButton.enabled = YES;
            self.nextPageButton.enabled = YES;
        }
        else
        {
            self.previousPageButton.enabled = NO;
            self.nextPageButton.enabled = NO;
        }
        for (int i = 0; i < [self.objects count]; i++)
        {
            match = self.objects[i];
            [self.titles addObject:[match valueForKey:@"title"]];
            int minutes = [[match valueForKey:@"minutes"] intValue];
            int hours = [[match valueForKey:@"hours"] intValue];
            NSNumber *totalMinutes = [NSNumber numberWithInt:minutes + hours * 60];
            [self.times addObject:totalMinutes];
        }
        NSUInteger remainder = [self.objects count] % 7;
        if (remainder == 0)
        {
            self.totalPageNumber = [self.objects count] / 7;
            self.currentPageNumber = 1;
        }
        else
        {
            self.totalPageNumber = ([self.objects count] - remainder) / 7 + 1;
            self.currentPageNumber = 1;
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
