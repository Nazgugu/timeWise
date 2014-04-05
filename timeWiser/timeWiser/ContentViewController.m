//
//  ContentViewController.m
//  timeWiser
//
//  Created by Liu Zhe on 3/31/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "ContentViewController.h"
#import "SFRoundProgressCounterView.h"

/* 1000 is 1 second*/
@interface ContentViewController ()<SFRoundProgressCounterViewDelegate>
@property (weak, nonatomic) IBOutlet SFRoundProgressCounterView *timeCounter;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _label.text = _labelString;
    //circular timer
    self.timeCounter.delegate = self;
    NSNumber *interval = [NSNumber numberWithLong:120 * 1000];
    self.timeCounter.intervals = @[interval];
    self.timeCounter.outerCircleThickness = [NSNumber numberWithLong:3.0];
    self.color = [UIColor blueColor];
}

#pragma mark = SFRoundProgressTimerViewDelegate
- (void)countdownDidEnd:(SFRoundProgressCounterView*)progressTimerView
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.controlButton setTitle:@"START" forState:UIControlStateNormal];
        //        [self.progressCounterView reset];
    });
}

/*- (void)intervalDidEnd:(SFRoundProgressCounterView *)progressTimerView WithIntervalPosition:(int)position
{
}*/


- (IBAction)controlAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // start
        if ([button.currentTitle isEqualToString:@"START"]) {
            
            [self.timeCounter start];
            [self.controlButton setTitle:@"STOP" forState:UIControlStateNormal];
            // stop
        } else if ([button.currentTitle isEqualToString:@"STOP"]) {
            
            [self.timeCounter stop];
            [self.controlButton setTitle:@"RESUME" forState:UIControlStateNormal];
            // resume
        } else {
            
            [self.timeCounter resume];
            [self.controlButton setTitle:@"STOP" forState:UIControlStateNormal];
        }
    });

}

- (IBAction)actionRestart:(id)sender {
    [self.controlButton setTitle:@"STOP" forState:UIControlStateNormal];
    [self.timeCounter start];
}

#pragma mark - color
- (void)setColor:(UIColor *)color
{
    if (color) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeCounter.innerProgressColor = color;
            self.timeCounter.outerProgressColor = color;
            self.timeCounter.labelColor = color;
            
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
            [self.controlButton setTitle:@"START" forState:UIControlStateNormal];
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
