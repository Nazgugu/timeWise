//
//  CDViewController.m
//  timeWiser
//
//  Created by Liu Zhe on 3/30/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDViewController.h"
#import "ContentViewController.h"
#import "TasksViewController.h"
#import "TodayViewController.h"
#import "UIColor+MLPFlatColors.h"

@interface CDViewController () <ViewPagerDataSource, ViewPagerDelegate>
@property (nonatomic) NSUInteger numberOfTabs;
@end

@implementation CDViewController

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {}

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [[UIColor flatWhiteColor] colorWithAlphaComponent:1.0f];
    UIFont *font = [UIFont fontWithName:@"Avenir Next" size:19.0f];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor flatDarkBlackColor]};
    self.navigationItem.titleView.tintColor = [UIColor flatDarkBlackColor];
    self.navigationController.navigationBar.titleTextAttributes = attribute;
    self.title = @"T I M E    W I S E R";
    self.dataSource = self;
    self.delegate = self;
    [self loadContent];
    //[self selectTabAtIndex:1];
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}

#pragma mark - Helpers
- (void)selectTabWithNumberFive {
    [self selectTabAtIndex:1];
}
- (void)loadContent {
    self.numberOfTabs = 3;
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:12.0];
    label.textColor = [UIColor flatBlackColor];
    if (index == 0)
    {
        label.text = [NSString stringWithFormat:@"TODAY"];
    }
    else if (index == 1)
    {
        label.text = [NSString stringWithFormat:@"TIMER"];
    }
    else if (index == 2)
    {
        label.text = [NSString stringWithFormat:@"TASKS"];
    }
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if (index == 1)
    {
    ContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    cvc.view.backgroundColor = [UIColor flatWhiteColor];
    cvc.timeCounter.backgroundColor = [UIColor flatWhiteColor];
    cvc.timeCounter.innerProgressColor = [[UIColor flatBlueColor] colorWithAlphaComponent:0.8f];
    cvc.timeCounter.outerProgressColor = [[UIColor flatBlueColor] colorWithAlphaComponent:0.8f];
    cvc.timeCounter.outerTrackColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    cvc.timeCounter.outerCircleThickness = [NSNumber numberWithDouble:4.0f];
    cvc.timeCounter.innerCircleThickness = [NSNumber numberWithDouble:1.0f];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isEmpty"] boolValue] == NO)
    {
        NSLog(@"I am not empty");
        int minutes = [[[NSUserDefaults standardUserDefaults] objectForKey:@"minutes"] intValue];
        int hours = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hours"] intValue];
        long time = (minutes * 60 + hours * 3600) * 1000;
        cvc.intervals = @[[NSNumber numberWithLong:time]];
    }
    return cvc;
    }
    else if (index == 0)
    {
        TodayViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TodayViewController"];
        return tvc;
    }
    else if (index == 2)
    {
        TasksViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"TasksViewController"];
        [avc.taskTable reloadData];
        return avc;
    }
    return nil;
}

#pragma mark - ViewPagerDelegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    if (index == 2)
    {
        TasksViewController *currentController = (TasksViewController *)[self viewPager:self contentViewControllerForTabAtIndex:index];
        [currentController.taskTable reloadData];
    }
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 1.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 49.0;
        case ViewPagerOptionTabOffset:
            return 0.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 106.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}



- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor flatTealColor] colorWithAlphaComponent:0.84];
        case ViewPagerTabsView:
            return [[UIColor flatWhiteColor] colorWithAlphaComponent:1.0];
        case ViewPagerContent:
            return [[UIColor flatDarkGrayColor] colorWithAlphaComponent:0.32];//0.32
        default:
            return color;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
