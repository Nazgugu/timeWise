//
//  CDViewController.m
//  timeWiser
//
//  Created by Liu Zhe on 3/30/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "CDViewController.h"
#import "HMSegmentedControl.h"

#define allowAppearance NO

@interface CDViewController ()
//@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation CDViewController


- (void)loadView
{
    [super loadView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil/*@selector(add)*/];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    HMSegmentedControl *topControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, 320, 45)];
    topControl.sectionTitles = @[@"TODAY", @"TIMER", @"TASKS"];
    topControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    topControl.selectedSegmentIndex = 1;
    topControl.backgroundColor = [UIColor whiteColor];
    topControl.textColor = [UIColor blackColor];
    topControl.selectedTextColor = [UIColor blueColor];
    topControl.selectionIndicatorColor = [UIColor whiteColor];
    topControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    topControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    topControl.selectionIndicatorColor = [UIColor blueColor];
    [self.view addSubview:topControl];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	NSLog(@"Selected index %ld (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
	NSLog(@"Selected index %ld", segmentedControl.selectedSegmentIndex);
}


#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
