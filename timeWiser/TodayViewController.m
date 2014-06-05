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


@interface TodayViewController ()<PNChartDelegate, UIScrollViewDelegate>
{
    NSArray *colorArray;
}
//@property (weak, nonatomic) IBOutlet UIButton *previousPageButton;
//@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *times;
@property (strong, nonatomic) PNBarChart *TaskChart;
@property (strong, nonatomic) PNCircleChart *timeChart;
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSMutableArray *colors;
@property (strong, nonatomic) NSMutableArray *showingTitles;
@property (strong, nonatomic) NSMutableArray *showingTime;
@property (nonatomic) BOOL chosen;
@property (nonatomic) NSInteger chosenTask;
@property (nonatomic) NSInteger previousValue;
@property (nonatomic) NSInteger currentPageNumber;
@property (nonatomic) NSInteger totalTime;
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;
@property (weak, nonatomic) IBOutlet UICountingLabel *taskTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) NSInteger totalPageNumber;
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
    //NSLog(@"view will appear is called");
    [super viewWillAppear:animated];
    [self updateChartWithPage:1];
}

- (void)loadView
{
    //NSLog(@"load view is called");
    [super loadView];
    //[self fetchContents];
    self.TaskChart.backgroundColor = [UIColor clearColor];
    self.TaskChart.barBackgroundColor = PNLightGrey;
}

- (void)updateChartWithPage:(NSInteger)pageNumber
{
    //NSLog(@"Page Number = %ld",(unsigned long)pageNumber);
    self.TaskChart.showLabel = YES;
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
        NSInteger startingLocation = (pageNumber - 1) * 7;
        NSInteger endingLocation = startingLocation + 6;
        //NSLog(@"starting location = %ld",(long)startingLocation);
        //NSLog(@"ending location = %ld",(long)endingLocation);
        range.location = startingLocation;
        if (endingLocation > [self.objects count])
        {
            range.length = [self.objects count] % 7;
            //NSLog(@"length = %lu",(unsigned long)range.length);
        }
        else
        {
            range.length = 7;
            //NSLog(@"length = %lu",(unsigned long)range.length);
        }
        [self.showingTitles addObjectsFromArray:[self.titles subarrayWithRange:range]];
        [self.showingTime addObjectsFromArray:[self.times subarrayWithRange:range]];
    }
    for (int i = 0; i < [self.showingTitles count]; i++)
    {
        index = i % 7;
        [self.colors addObject:[colorArray objectAtIndex:index]];
    }
    //[self.TaskChart removeFromSuperview];
    //[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.TaskChart = [[PNBarChart alloc] initWithFrame:CGRectMake((pageNumber - 1) * 320, 0, 320, 280)];
    self.TaskChart.backgroundColor = [UIColor clearColor];
    self.TaskChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    self.TaskChart.labelMarginTop = 5.0;
    /*[UIView transitionWithView:self.TaskChart
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.TaskChart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    } completion:^(BOOL finished){
                        [self.TaskChart setStrokeColors:self.colors];
                        [self.TaskChart setXLabels:self.showingTitles];
                        //[self.TaskChart setTimeLabel:self.showingTime];
                        [self.TaskChart setYValues:self.showingTime];
                        [self.TaskChart strokeChart];
                    }];*/
    //NSLog(@"%@",self.showingTitles);
    self.TaskChart.delegate = self;
    self.TaskChart.labelFont = [UIFont fontWithName:@"Avenir Next" size:11.0f];
    //[self.TaskChart.xLabels removeAllObjects];
    //[self.TaskChart.yValues removeAllObjects];
    //[self.TaskChart.strokeColors removeAllObjects];
    //NSLog(@"number of showing titles = %u",(unsigned int)self.showingTitles.count);
    //NSLog(@"number of showing time = %u",(unsigned int)self.showingTime.count);
    self.TaskChart.xLabels = self.showingTitles;
    self.TaskChart.yValues = self.showingTime;
    //[self.TaskChart setYValues:self.showingTime];
    self.TaskChart.strokeColors = self.colors;
    //[self.TaskChart setStrokeColors:self.colors];
    [self.TaskChart strokeChart];
    [self.scrollView addSubview:self.TaskChart];
    //NSLog(@"number of bars = %lu",(unsigned long)self.TaskChart.bars.count);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"view did load is called");
    //[self fetchContents];
    colorArray = [[NSArray alloc] initWithObjects:[UIColor flatRedColor], [UIColor flatGreenColor], [UIColor flatBlueColor], [UIColor flatYellowColor], [UIColor flatPurpleColor], [UIColor flatTealColor], [UIColor flatGrayColor], nil];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy . MM . dd";
    NSDate *now = [NSDate date];
    NSString *dateString = [formatter stringFromDate:now];
    NSLog(@"%@",dateString);
    self.dateLabel.text = dateString;
    self.chosen = NO;
    self.chosenTask = 0;
    self.previousValue = 0;
    self.taskTime.method = UILabelCountingMethodEaseInOut;
    self.taskTime.format = @"%d";
    [self fetchContents];
    [self updateInfoWithObjectIndex:0];
    self.timeChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, self.timeView.frame.size.width, self.timeView.frame.size.height) andTotal:@100 andCurrent:@0 andClockwise:YES andShadow:YES];
    self.timeChart.backgroundColor = [UIColor clearColor];
    self.timeChart.total = @100;
    self.timeChart.current = @0;
    [self.timeChart setStrokeColor:[UIColor whiteColor]];
    [self.timeChart strokeChart];
    [self.timeView addSubview:self.timeChart];
    //[self updateChart];
}

- (void)updateInfoWithObjectIndex:(NSInteger)index
{
    if (self.chosen)
    {
        self.taskTitle.text = [self.titles objectAtIndex:index];
        [self.taskTime countFrom:self.previousValue to:[[self.times objectAtIndex:index] floatValue] withDuration:0.8];
        self.previousValue = [[self.times objectAtIndex:index] intValue];
        NSLog(@"total time = %ld",(long)self.totalTime);
        NSLog(@"current time = %ld",(long)[[self.times objectAtIndex:index] intValue]);
        int percent = (int)([[self.times objectAtIndex:index] intValue] * 100 / self.totalTime);
        NSLog(@"percent = %d",percent);
        self.timeChart.current = [NSNumber numberWithInt:percent];
        [self.timeChart setStrokeColor:[self.colors objectAtIndex:(index % 7)]];
        [self.timeChart strokeChart];
    }
    else
    {
        NSLog(@"no info yet");
        self.taskTitle.text = @"Title";
        [self.taskTime countFrom:self.previousValue to:0 withDuration:0.8];
        self.previousValue = 0;
        self.timeChart.current = @0;
        [self.timeChart strokeChart];
    }
}

//barChart Delegate method
#pragma mark = PNChart delegate
- (void)userClickedOnBarCharIndex:(NSInteger)barIndex
{
    NSLog(@"Click on bar %@", @(barIndex));
    //[self.TaskChart animateBarAtIndex:barIndex];
    PNBar * bar = [self.TaskChart.bars objectAtIndex:barIndex];
    if (bar.isScaled == YES)
    {
        NSLog(@"is scaled");
        CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        animation.fromValue= @1.1;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.toValue= @1.0;
        
        animation.duration= 0.2;
        
        animation.repeatCount = 0;
        
        animation.autoreverses = NO;
        
        animation.removedOnCompletion = NO;
        
        animation.fillMode=kCAFillModeForwards;
        
        [bar.layer addAnimation:animation forKey:@"Float"];
        bar.isScaled = NO;
        self.chosen = NO;
        [self updateInfoWithObjectIndex:0];
    }
    else
    {
        for (PNBar *tempBar in self.TaskChart.bars)
        {
            if (tempBar.isScaled == YES)
            {
                CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                
                animation.fromValue= @1.1;
                
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                animation.toValue= @1.0;
                
                animation.duration= 0.2;
                
                animation.repeatCount = 0;
                
                animation.autoreverses = NO;
                
                animation.removedOnCompletion = NO;
                
                animation.fillMode=kCAFillModeForwards;
                
                [tempBar.layer addAnimation:animation forKey:@"Float"];
                tempBar.isScaled = NO;
            }
        }
        NSLog(@"not scaled");
        CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
        animation.fromValue= @1.0;
    
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
        animation.toValue= @1.1;
    
        animation.duration= 0.2;
    
        animation.repeatCount = 0;
    
        animation.autoreverses = NO;
    
        animation.removedOnCompletion = NO;
    
        animation.fillMode=kCAFillModeForwards;
    
        [bar.layer addAnimation:animation forKey:@"Float"];
        bar.isScaled = YES;
        self.chosen = YES;
        NSInteger index = (self.currentPageNumber - 1) * 7 + barIndex;
        [self updateInfoWithObjectIndex:index];
    }

}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

-(void)updateChart:(NSInteger)pageNumber
{
    if (pageNumber == self.currentPageNumber)
    {
        //NSLog(@"equal, page number = %ld, currentpage = %ld",(long)pageNumber,(long)self.currentPageNumber);
    }
    else
    {
        //NSLog(@"not equal, page number = %ld, currentpage = %ld",(long)pageNumber,(long)self.currentPageNumber);
        for (PNBar *tempBar in self.TaskChart.bars)
        {
            if (tempBar.isScaled == YES)
            {
                CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                
                animation.fromValue= @1.1;
                
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                animation.toValue= @1.0;
                
                animation.duration= 0.2;
                
                animation.repeatCount = 0;
                
                animation.autoreverses = NO;
                
                animation.removedOnCompletion = NO;
                
                animation.fillMode=kCAFillModeForwards;
                
                [tempBar.layer addAnimation:animation forKey:@"Float"];
                tempBar.isScaled = NO;
            }
        }
        [self updateChartWithPage:pageNumber];
        self.currentPageNumber = self.pageControl.currentPage + 1;
        self.chosen = NO;
        [self updateInfoWithObjectIndex:0];
    }
}

//scrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"Scrolled");
    //CGFloat viewWidth = scrollView.frame.size.width;
    //int pageNumber =  floor((scrollView.contentOffset.x - viewWidth/50) / viewWidth) +1;
    //self.pageControl.currentPage = pageNumber;
    //NSLog(@"Page Number = %ld",(unsigned long)self.pageControl.currentPage + 1);
    //NSLog(@"content offset X = %f",self.scrollView.contentOffset.x);
    //NSLog(@"content inset X = %f",self.scrollView.contentInset.bottom);
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    NSLog(@"new Page Number = %ld",(unsigned long)self.pageControl.currentPage);
    NSLog(@"current page Number = %ld",(unsigned long)self.currentPageNumber);
    NSLog(@"\n");
    [self updateChart:self.pageControl.currentPage + 1];
}

/*-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat viewWidth = scrollView.frame.size.width;
    int pageNumber =  floor((scrollView.contentOffset.x - viewWidth/50) / viewWidth) +1;
    self.pageControl.currentPage = pageNumber;
}*/

- (IBAction)pageChanged:(id)sender {
    if (self.pageControl.currentPage + 1 != self.currentPageNumber)
    {
        //[self updateChartWithPage:self.pageControl.currentPage];
        NSLog(@"Not equal");
        for (PNBar *tempBar in self.TaskChart.bars)
        {
            if (tempBar.isScaled == YES)
            {
                CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                
                animation.fromValue= @1.1;
                
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                animation.toValue= @1.0;
                
                animation.duration= 0.2;
                
                animation.repeatCount = 0;
                
                animation.autoreverses = NO;
                
                animation.removedOnCompletion = NO;
                
                animation.fillMode=kCAFillModeForwards;
                
                [tempBar.layer addAnimation:animation forKey:@"Float"];
                tempBar.isScaled = NO;
            }
        }
        self.currentPageNumber = self.pageControl.currentPage + 1;
        [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * 320, 0) animated:YES];
        [self updateChartWithPage:self.pageControl.currentPage + 1];
    }
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
        //self.previousPageButton.enabled = NO;
        //self.nextPageButton.enabled = NO;
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
            //self.previousPageButton.enabled = YES;
            //self.nextPageButton.enabled = YES;
        }
        else
        {
            //self.previousPageButton.enabled = NO;
            //self.nextPageButton.enabled = NO;
        }
        NSLog(@"total number of tasks = %lu",(unsigned long)self.objects.count);
        self.totalTime = 0;
        for (int i = 0; i < [self.objects count]; i++)
        {
            match = self.objects[i];
            [self.titles addObject:[match valueForKey:@"title"]];
            int minutes = [[match valueForKey:@"minutes"] intValue];
            int hours = [[match valueForKey:@"hours"] intValue];
            NSNumber *totalMinutes = [NSNumber numberWithInt:minutes + hours * 60];
            [self.times addObject:totalMinutes];
            self.totalTime += [totalMinutes intValue];
        }
        NSInteger remainder = [self.objects count] % 7;
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
    self.pageControl.numberOfPages = self.totalPageNumber;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width*self.totalPageNumber,self.scrollView.frame.size.height)];
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
