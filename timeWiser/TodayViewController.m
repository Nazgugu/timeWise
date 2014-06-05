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
@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *times;
@property (strong, nonatomic) PNBarChart *TaskChart;
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSMutableArray *colors;
@property (strong, nonatomic) NSMutableArray *showingTitles;
@property (strong, nonatomic) NSMutableArray *showingTime;
@property (nonatomic) NSInteger currentPageNumber;
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
    [self fetchContents];
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
    NSLog(@"Page Number = %ld",(unsigned long)pageNumber);
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
        NSLog(@"starting location = %ld",(long)startingLocation);
        NSLog(@"ending location = %ld",(long)endingLocation);
        range.location = startingLocation;
        if (endingLocation > [self.objects count])
        {
            range.length = [self.objects count] % 7;
            NSLog(@"length = %lu",(unsigned long)range.length);
        }
        else
        {
            range.length = 7;
            NSLog(@"length = %lu",(unsigned long)range.length);
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
    [self.TaskChart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    //[self updateChart];
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
    //NSLog(@"new Page Number = %ld",(unsigned long)page);
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
        for (int i = 0; i < [self.objects count]; i++)
        {
            match = self.objects[i];
            [self.titles addObject:[match valueForKey:@"title"]];
            int minutes = [[match valueForKey:@"minutes"] intValue];
            int hours = [[match valueForKey:@"hours"] intValue];
            NSNumber *totalMinutes = [NSNumber numberWithInt:minutes + hours * 60];
            [self.times addObject:totalMinutes];
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
