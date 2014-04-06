//
//  ContentViewController.m
//  timeWiser
//
//  Created by Liu Zhe on 3/31/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "ContentViewController.h"

#import "UIColor+MLPFlatColors.h"
#import "JSQFlatButton.h"

/* 1000 is 1 second*/
@interface ContentViewController ()<SFRoundProgressCounterViewDelegate>

@property (weak, nonatomic) IBOutlet JSQFlatButton *controlButton;
@property (weak, nonatomic) IBOutlet JSQFlatButton *resetButton;

@end

@implementation ContentViewController

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
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *bkgImage = [UIImage imageNamed:@"bkg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bkgImage];
    // Do any additional setup after loading the view.
    //circular timer
    self.timeCounter.delegate = self;
    NSNumber *interval = [NSNumber numberWithLong:120 * 1000];
    self.timeCounter.intervals = @[interval];
    self.timeCounter.outerCircleThickness = [NSNumber numberWithLong:3.0];
    self.color = [[UIColor flatBlueColor] colorWithAlphaComponent:0.8f];
    self.view.backgroundColor = [UIColor flatWhiteColor];
    self.timeCounter.backgroundColor = [UIColor flatWhiteColor];
    self.controlButton.tintColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.8f];
    self.controlButton.borderWidth = 1.5f;
    self.controlButton.cornerRadius = (self.controlButton.frame.size.height + self.controlButton.frame.size.width) / 4;
    self.controlButton.normalBorderColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.8f];
    self.controlButton.highlightedBorderColor = [[UIColor flatDarkGreenColor] colorWithAlphaComponent:0.8f];
    self.resetButton.tintColor = [[UIColor flatYellowColor] colorWithAlphaComponent:0.8f];
    self.resetButton.cornerRadius = (self.resetButton.frame.size.height + self.resetButton.frame.size.width) / 4;
    self.resetButton.borderWidth = 1.5f;
    self.resetButton.normalBorderColor = [[UIColor flatYellowColor] colorWithAlphaComponent:0.8f];
    self.resetButton.highlightedBorderColor = [[UIColor flatDarkYellowColor] colorWithAlphaComponent:0.8f];
}

#pragma mark = SFRoundProgressTimerViewDelegate
- (void)countdownDidEnd:(SFRoundProgressCounterView*)progressTimerView
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.controlButton setTitle:@"New" forState:UIControlStateNormal];
        //        [self.progressCounterView reset];
    });
}

/*- (void)intervalDidEnd:(SFRoundProgressCounterView *)progressTimerView WithIntervalPosition:(int)position
{
}*/


- (IBAction)controlAction:(id)sender {
    JSQFlatButton *button = (JSQFlatButton *)sender;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // start
        if ([button.currentTitle isEqualToString:@"Start"]) {
            
            [self.timeCounter start];
            [self.controlButton setTitle:@"Pause" forState:UIControlStateNormal];
            [self.controlButton setTintColor:[[UIColor flatRedColor] colorWithAlphaComponent:0.8f]];
            self.controlButton.normalBorderColor = [[UIColor flatRedColor] colorWithAlphaComponent:0.8f];
            self.controlButton.highlightedBorderColor = [[UIColor flatDarkRedColor] colorWithAlphaComponent:0.8f];
            // stop
        } else if ([button.currentTitle isEqualToString:@"Pause"]) {
            
            [self.timeCounter stop];
            [self.controlButton setTitle:@"Resume" forState:UIControlStateNormal];
            self.controlButton.normalBorderColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.8f];
            self.controlButton.highlightedBorderColor = [[UIColor flatDarkGreenColor] colorWithAlphaComponent:0.8f];
            [self.controlButton setTintColor:[[UIColor flatGreenColor] colorWithAlphaComponent:0.8f]];
            // resume
        } else {
            
            [self.timeCounter resume];
            [self.controlButton setTitle:@"Pause" forState:UIControlStateNormal];
            [self.controlButton setTintColor:[[UIColor flatRedColor] colorWithAlphaComponent:0.8f]];
            self.controlButton.normalBorderColor = [[UIColor flatRedColor] colorWithAlphaComponent:0.8f];
            self.controlButton.highlightedBorderColor = [[UIColor flatDarkRedColor] colorWithAlphaComponent:0.8f];
        }
    });
    
}

- (IBAction)actionReset:(id)sender {
    [self.controlButton setTitle:@"Start" forState:UIControlStateNormal];
    self.controlButton.normalBorderColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.8f];
    self.controlButton.highlightedBorderColor = [[UIColor flatDarkGreenColor] colorWithAlphaComponent:0.8f];
    [self.resetButton setTintColor:[[UIColor flatYellowColor] colorWithAlphaComponent:0.8f]];
    [self.controlButton setTintColor:[[UIColor flatGreenColor] colorWithAlphaComponent:0.8f]];
    [self.timeCounter reset];
}

#pragma mark - color
- (void)setColor:(UIColor *)color
{
    if (color) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeCounter.innerProgressColor = color;
            self.timeCounter.outerProgressColor = color;
            self.timeCounter.labelColor = color;
            self.resetButton.tintColor = [[UIColor flatYellowColor] colorWithAlphaComponent:0.8f];
            self.controlButton.tintColor = color;
        });
    }
}

- (void)setBgColor:(UIColor *)bgColor
{
    if (bgColor) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeCounter.backgroundColor = bgColor;
        });
    }
}

- (void)setIntervals:(NSArray *)intervals
{
    if (intervals) {
        NSLog(@"I have intervals");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.controlButton setTitle:@"Start" forState:UIControlStateNormal];
            [self.controlButton setTintColor:[[UIColor flatGreenColor] colorWithAlphaComponent:0.8f]];
            [self.resetButton setTintColor:[[UIColor flatYellowColor] colorWithAlphaComponent:0.8f]];
            [self.timeCounter stop];
            _intervals = intervals;
            self.timeCounter.intervals = intervals;
        });
    }
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
