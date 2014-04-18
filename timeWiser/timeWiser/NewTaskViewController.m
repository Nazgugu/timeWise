//
//  NewTaskViewController.m
//  timeWiser
//
//  Created by Liu Zhe on 4/2/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import "NewTaskViewController.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "CDAppDelegate.h"
#import "UIColor+MLPFlatColors.h"
#import "APLKeyboardControls.h"
#import "TSMessage.h"
#import "JSQFlatButton.h"

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface NewTaskViewController ()
@property (strong, nonatomic) JVFloatLabeledTextField *titleField;
@property (strong, nonatomic) JVFloatLabeledTextView *descriptionField;
@property (nonatomic) BOOL isSucceeded;
@property (nonatomic) BOOL isShortCut;
@property (nonatomic) NSInteger shortCutNum;
@property (nonatomic) NSInteger setMin;
@property (nonatomic) NSInteger setHr;
@property (strong, nonatomic) APLKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UILabel *displayMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *tinyLabel;
@property (weak, nonatomic) IBOutlet JSQFlatButton *workButton;
@property (weak, nonatomic) IBOutlet JSQFlatButton *playButton;
@property (weak, nonatomic) IBOutlet JSQFlatButton *sportButton;
@property (weak, nonatomic) IBOutlet JSQFlatButton *cookButton;
@end

@implementation NewTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupDesign{
    self.view.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setupTimeSelector{
    [self.timeSelector addTarget:self action:@selector(timeSelectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    UIColor *redColor = [UIColor flatRedColor];
    UIColor *blueColor = [UIColor flatBlueColor];
    UIColor *greenColor = [UIColor flatGreenColor];
    
    SAMultisectorSector *sector1 = [SAMultisectorSector sectorWithColor:redColor maxValue:16.0];
    SAMultisectorSector *hours = [SAMultisectorSector sectorWithColor:blueColor maxValue:23.0];
    SAMultisectorSector *minutes = [SAMultisectorSector sectorWithColor:greenColor maxValue:60.0];
    
    sector1.tag = 0;
    hours.tag = 1;
    minutes.tag = 2;
    
    //sector1.endValue = 1.0;
    //sector1.startValue = 0.0;
    hours.endValue = 0.0;
    hours.startValue = 0.0;
    minutes.startValue = 0.0;
    minutes.endValue = 25.0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight == 480)
    {
        NSLog(@"I am a 3.5inch screen");
        NSLog(@"screen height = %f",screenHeight);
        self.timeSelector.sectorsRadius = 43.0f;
    }
    else
    {
        NSLog(@"I am a 4 inch screen");
        NSLog(@"screen height = %f",screenHeight);
        self.timeSelector.sectorsRadius = 60.0f;
    }
    NSLog(@"radius = %f", self.timeSelector.sectorsRadius);
    NSLog(@"height = %lf, width = %lf",self.timeSelector.frame.size.height, self.timeSelector.frame.size.width);
    self.timeSelector.minCircleMarkerRadius = 4.0f;
    self.timeSelector.maxCircleMarkerRadius = 7.0f;
    NSLog(@"min marker radius = %lf, max = %lf",self.timeSelector.minCircleMarkerRadius, self.timeSelector.maxCircleMarkerRadius);
    //[self.timeSelector addSector:sector1];
    [self.timeSelector addSector:hours];
    [self.timeSelector addSector:minutes];
    [self updateDataView];
}

- (void)updateDataView
{
    for (SAMultisectorSector *sector in self.timeSelector.sectors)
    {
        double totalTime;
        if (sector.tag == 1)
        {
            totalTime = sector.endValue - sector.startValue;
            self.hoursLabel.text = [NSString stringWithFormat:@"%.0f", totalTime];
        }
        if (sector.tag == 2)
        {
            totalTime = sector.endValue - sector.startValue;
            self.minutesLabel.text = [NSString stringWithFormat:@"%.0f", totalTime];
        }
    }
}

//do something when the timeselector value changed
- (void)timeSelectorValueChanged:(id)sender
{
    [self.view endEditing:YES];
    [self updateDataView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.shortCutNum = 4;
    self.isSucceeded = NO;
    self.hoursLabel.textColor = [UIColor flatDarkGrayColor];
    self.minutesLabel.textColor = [UIColor flatDarkGrayColor];
    CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height + 30.0f;
    UIColor *floatingLabelColor = [UIColor grayColor];
    if (!self.titleField)
    {
    self.titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, topOffset + 15 + 2, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    }
    self.titleField.placeholder = NSLocalizedString(@"Title", @"");
    self.titleField.floatingLabelActiveTextColor = [UIColor flatBlueColor];
    self.titleField.textColor = [UIColor flatBlackColor];
    self.titleField.font = [UIFont fontWithName:@"Avenir Next" size:kJVFieldFontSize];
    self.titleField.floatingLabel.font = [UIFont fontWithName:@"Avenir Next" size:kJVFieldFloatingLabelFontSize];
    self.titleField.floatingLabelTextColor = floatingLabelColor;
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleField.backgroundColor = [UIColor clearColor];
    //UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    //titleField.leftView = leftView;
    //titleField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.titleField];
    
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin, self.titleField.frame.origin.y + self.titleField.frame.size.height,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    if (!self.descriptionField)
    {
    self.descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
    self.descriptionField.frame = CGRectMake(kJVFieldHMargin - self.descriptionField.textContainer.lineFragmentPadding,
                                        div1.frame.origin.y + div1.frame.size.height,
                                        self.view.frame.size.width - 2*kJVFieldHMargin + self.descriptionField.textContainer.lineFragmentPadding,
                                        kJVFieldHeight * 2);
    }
    self.descriptionField.placeholder = NSLocalizedString(@"Description (optional)", @"");
    self.descriptionField.font = [UIFont fontWithName:@"Avenir Next" size:kJVFieldFontSize];
    self.descriptionField.floatingLabelActiveTextColor = [UIColor flatBlueColor];
    self.descriptionField.floatingLabel.font = [UIFont fontWithName:@"Avenir Next" size:kJVFieldFloatingLabelFontSize];
    self.descriptionField.floatingLabelTextColor = floatingLabelColor;
    self.descriptionField.textColor = [UIColor flatBlackColor];
    self.descriptionField.backgroundColor = [UIColor clearColor];
    self.descriptionField.opaque = NO;
    [self.view addSubview:self.descriptionField];
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(kJVFieldHMargin, self.descriptionField.frame.origin.y + self.descriptionField.frame.size.height,
                            self.view.frame.size.width - 2*kJVFieldHMargin, 1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div3];
    // 4 type buttons
    self.workButton.borderWidth = 1.0f;
    self.workButton.cornerRadius = 12.0f;
    self.workButton.normalBorderColor = [[UIColor flatRedColor] colorWithAlphaComponent:0.8f];
    self.workButton.highlightedBorderColor = [[UIColor flatRedColor] colorWithAlphaComponent:0.8f];
    self.workButton.highlightedBackgroundColor = [[UIColor flatRedColor] colorWithAlphaComponent:0.8f];
    self.workButton.selec = NO;
    self.workButton.tag = 0;
    
    self.playButton.borderWidth = 0.7f;
    self.playButton.cornerRadius = 12.0f;
    self.playButton.normalBorderColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.8f];
    self.playButton.highlightedBorderColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.8f];
    self.playButton.highlightedBackgroundColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.8f];
    self.playButton.selec = NO;
    self.playButton.tag = 1;
    
    self.sportButton.borderWidth = 0.7f;
    self.sportButton.cornerRadius = 12.0f;
    self.sportButton.normalBorderColor = [[UIColor flatBlueColor] colorWithAlphaComponent:0.8f];
    self.sportButton.highlightedBorderColor = [[UIColor flatBlueColor] colorWithAlphaComponent:0.8f];
    self.sportButton.highlightedBackgroundColor = [[UIColor flatBlueColor] colorWithAlphaComponent:0.8f];
    self.sportButton.selec = NO;
    self.sportButton.tag = 2;
    
    self.cookButton.borderWidth = 0.7f;
    self.cookButton.cornerRadius = 12.0f;
    self.cookButton.normalBorderColor = [[UIColor flatYellowColor] colorWithAlphaComponent:0.8f];
    self.cookButton.highlightedBorderColor = [[UIColor flatYellowColor] colorWithAlphaComponent:0.8f];
    self.cookButton.highlightedBackgroundColor = [[UIColor flatYellowColor] colorWithAlphaComponent:0.8f];
    self.cookButton.selec =NO;
    self.cookButton.tag = 3;
    
    self.isShortCut = NO;
    //set delegate
    self.titleField.delegate = self;
    //priceField.delegate = self;
    //locationField.delegate = self;
    self.displayMinLabel.textColor = [UIColor flatGreenColor];
    self.displayHourLabel.textColor = [UIColor flatBlueColor];
    self.tinyLabel.textColor = [UIColor flatGrayColor];
    NSArray *inputChain = @[self.titleField, self.descriptionField];
    self.keyboardControls = [[APLKeyboardControls alloc] initWithInputFields:inputChain];
    self.keyboardControls.hasPreviousNext = YES;
    //self.keyboardControls.doneButton.tintColor = [UIColor blueColor];
    [self setupDesign];
    [self setupTimeSelector];
    //[titleField becomeFirstResponder];
}
- (IBAction)addTask:(id)sender {
    if ([self.titleField.text  isEqualToString:@""] && !self.isShortCut)
    {
        [self.titleField becomeFirstResponder];
        [TSMessage showNotificationInViewController:self
                                              title:@"Missing Title"
                                           subtitle:@"Title Cannot Be Left Blank"
                                              image:nil
                                               type:TSMessageNotificationTypeWarning
                                           duration:1.2
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
        return;
    }
    /*if ([self.descriptionField.text isEqualToString:@""])
    {
        [self.descriptionField becomeFirstResponder];
        return;
    }*/
    self.setMin = [self.minutesLabel.text intValue];
    self.setHr = [self.hoursLabel.text intValue];
    if (self.setMin == 0 && self.setHr ==0)
    {
        [TSMessage showNotificationInViewController:self
                                              title:@"Set Duration"
                                           subtitle:@"Time Duration Could Not Be Set To Zero"
                                              image:nil
                                               type:TSMessageNotificationTypeWarning
                                           duration:1.2
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
        return;
    }
    self.isSucceeded = YES;
    CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newTask;
    newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    [newTask setValue:[NSNumber numberWithInt:(int)self.setMin] forKey:@"minutes"];
    [newTask setValue:[NSNumber numberWithInt:(int)self.setHr]  forKey:@"hours"];
    [newTask setValue:self.titleField.text forKey:@"title"];
    [newTask setValue:self.descriptionField.text forKey:@"details"];
    [newTask setValue:[NSNumber numberWithBool:NO] forKey:@"isCompleted"];
    [newTask setValue:nil forKey:@"completeDate"];
    NSError *error;
    [context save:&error];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isSelected"] boolValue] == NO)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isInProgress"] boolValue] == NO)
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isEmpty"] boolValue] == YES)
            {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isEmpty"];
            }
            //save the object ID
            NSManagedObjectID *objID = [newTask objectID];
            NSURL *url = [objID URIRepresentation];
            NSData *urlData = [NSKeyedArchiver archivedDataWithRootObject:url];
            [[NSUserDefaults standardUserDefaults] setObject:urlData forKey:@"taskID"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isEmpty"]; //set isEmpty to No
            [[NSUserDefaults standardUserDefaults] setObject:self.titleField.text forKey:@"title"];
            [[NSUserDefaults standardUserDefaults] setObject:self.descriptionField.text forKey:@"detail"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)self.setMin] forKey:@"minutes"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)self.setHr] forKey:@"hours"];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"unwind" sender:sender];
}
- (IBAction)cancelCreation:(id)sender {
    [self performSegueWithIdentifier:@"unwind" sender:sender];
}

- (IBAction)typeSelected:(id)sender {
    JSQFlatButton *button;
    if ([sender isKindOfClass:[JSQFlatButton class]])
    {
        button = (JSQFlatButton *)sender;
    }
    if (button.selec == YES)
    {
        self.shortCutNum = 4;
        self.isShortCut = NO;
        switch (button.tag) {
            case 0:
            {
                self.workButton.selec = NO;
                //self.workButton.selected = NO;
                self.workButton.normalBackgroundColor = nil;
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Work" withString:@""];
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Wor" withString:@""];
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Wo" withString:@""];
                break;
            }
            case 1:
            {
                self.playButton.selec = NO;
                //self.playButton.selected = NO;
                self.playButton.normalBackgroundColor = nil;
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Play" withString:@""];
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Pla" withString:@""];
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Pl" withString:@""];
                break;
            }
            case 2:
            {
                self.sportButton.selec = NO;
                //self.sportButton.selected = NO;
                self.sportButton.normalBackgroundColor = nil;
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Sport" withString:@""];
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Spor" withString:@""];
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Spo" withString:@""];
                break;
            }
            case 3:
            {
                self.cookButton.selec = NO;
                //self.cookButton.selected = NO;
                self.cookButton.normalBackgroundColor = nil;
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Cook" withString:@""];
                self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Coo" withString:@""];
                break;
            }
            default:
                break;
        }
        [self.workButton setTitleColor:[UIColor flatBlackColor] forState:UIControlStateNormal];
        [self.playButton setTitleColor:[UIColor flatBlackColor] forState:UIControlStateNormal];
        [self.sportButton setTitleColor:[UIColor flatBlackColor] forState:UIControlStateNormal];
        [self.cookButton setTitleColor:[UIColor flatBlackColor] forState:UIControlStateNormal];
    }
    else
    {
        switch (button.tag) {
            case 0:
            {
                self.workButton.normalBackgroundColor = [[UIColor flatRedColor] colorWithAlphaComponent:0.8f];
                self.playButton.normalBackgroundColor = nil;
                self.sportButton.normalBackgroundColor = nil;
                self.cookButton.normalBackgroundColor = nil;
                //self.workButton.titleLabel.textColor = [UIColor flatWhiteColor];
                [self.workButton setTitleColor:[UIColor flatWhiteColor] forState:UIControlStateNormal];
                self.playButton.titleLabel.textColor = [UIColor flatBlackColor];
                self.sportButton.titleLabel.textColor = [UIColor flatBlackColor];
                self.cookButton.titleLabel.textColor = [UIColor flatBlackColor];
                if (self.isShortCut)
                {
                    if (self.playButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Play" withString:@"Work"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Pla" withString:@"Work"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Pl" withString:@"Work"];
                    }
                    if (self.sportButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Sport" withString:@"Work"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Spor" withString:@"Work"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Spo" withString:@"Work"];
                    }
                    if (self.cookButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Cook" withString:@"Work"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Coo" withString:@"Work"];
                    }
                }
                else
                {
                    NSString *temp = @"Work";
                    self.titleField.text = [temp stringByAppendingString:self.titleField.text];
                }
                self.workButton.selec = YES;
                //self.workButton.selected = NO;
                self.playButton.selec = NO;
                self.sportButton.selec = NO;
                self.cookButton.selec = NO;
                break;
            }
            case 1:
            {
                self.playButton.normalBackgroundColor = [[UIColor flatGreenColor] colorWithAlphaComponent:0.8f];
                self.workButton.normalBackgroundColor = nil;
                self.sportButton.normalBackgroundColor = nil;
                self.cookButton.normalBackgroundColor = nil;
                self.workButton.titleLabel.textColor = [UIColor flatBlackColor];
                [self.playButton setTitleColor:[UIColor flatWhiteColor] forState:UIControlStateNormal];
                self.sportButton.titleLabel.textColor = [UIColor flatBlackColor];
                self.cookButton.titleLabel.textColor = [UIColor flatBlackColor];
                if (self.isShortCut)
                {
                    if (self.workButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Work" withString:@"Play"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Wor" withString:@"Play"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Wo" withString:@"Play"];
                    }
                    if (self.sportButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Sport" withString:@"Play"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Spor" withString:@"Play"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Spo" withString:@"Play"];
                    }
                    if (self.cookButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Cook" withString:@"Play"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Coo" withString:@"Play"];
                    }

                }
                else
                {
                    NSString *temp = @"Play";
                    self.titleField.text = [temp stringByAppendingString:self.titleField.text];
                }
                self.playButton.selec = YES;
                //self.playButton.selected = NO;
                self.workButton.selec = NO;
                self.sportButton.selec = NO;
                self.cookButton.selec = NO;
                break;
            }
            case 2:
            {
                self.sportButton.normalBackgroundColor = [[UIColor flatBlueColor] colorWithAlphaComponent:0.8f];
                self.playButton.normalBackgroundColor = nil;
                self.workButton.normalBackgroundColor = nil;
                self.cookButton.normalBackgroundColor = nil;
                self.workButton.titleLabel.textColor = [UIColor flatBlackColor];
                self.playButton.titleLabel.textColor = [UIColor flatBlackColor];
                [self.sportButton setTitleColor:[UIColor flatWhiteColor] forState:UIControlStateNormal];
                self.cookButton.titleLabel.textColor = [UIColor flatBlackColor];
                if (self.isShortCut)
                {
                    if (self.workButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Work" withString:@"Sport"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Wor" withString:@"Sport"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Wo" withString:@"Sport"];
                    }
                    if (self.playButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Play" withString:@"Sport"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Pla" withString:@"Sport"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Pl" withString:@"Sport"];
                    }
                    if (self.cookButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Cook" withString:@"Sport"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Coo" withString:@"Sport"];
                    }

                }
                else
                {
                    NSString *temp = @"Sport";
                    self.titleField.text = [temp stringByAppendingString:self.titleField.text];
                }
                self.sportButton.selec = YES;
                //self.sportButton.selected = NO;
                self.playButton.selec = NO;
                self.workButton.selec = NO;
                self.cookButton.selec = NO;
                break;
            }
            case 3:
            {
                self.cookButton.normalBackgroundColor = [[UIColor flatYellowColor] colorWithAlphaComponent:0.8f];
                self.playButton.normalBackgroundColor = nil;
                self.sportButton.normalBackgroundColor = nil;
                self.workButton.normalBackgroundColor = nil;
                self.workButton.titleLabel.textColor = [UIColor flatBlackColor];
                self.playButton.titleLabel.textColor = [UIColor flatBlackColor];
                self.sportButton.titleLabel.textColor = [UIColor flatBlackColor];
                [self.cookButton setTitleColor:[UIColor flatWhiteColor] forState:UIControlStateNormal];
                if (self.isShortCut)
                {
                    if (self.workButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Work" withString:@"Cook"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Wor" withString:@"Cook"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Wo" withString:@"Cook"];
                    }
                    if (self.playButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Play" withString:@"Cook"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Pla" withString:@"Cook"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Pl" withString:@"Cook"];
                    }
                    if (self.sportButton.selec)
                    {
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Sport" withString:@"Cook"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Spor" withString:@"Cook"];
                        self.titleField.text = [self.titleField.text stringByReplacingOccurrencesOfString:@"Spo" withString:@"Cook"];
                    }
                }
                else
                {
                    NSString *temp = @"Cook";
                    self.titleField.text = [temp stringByAppendingString:self.titleField.text];
                }
                self.cookButton.selec = YES;
                //self.cookButton.selected = NO;
                self.playButton.selec = NO;
                self.sportButton.selec = NO;
                self.workButton.selec = NO;
                break;
            }
            default:
                break;
        }
        self.isShortCut = YES;
        self.shortCutNum = button.tag;
    }
}


//Dismiss keyboard when touch out side.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isKindOfClass:[JVFloatLabeledTextField class]])
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([textField isKindOfClass:[JVFloatLabeledTextField class]])
    {
        if (self.isShortCut)
        {
            if (self.shortCutNum < 4)
            {
                switch (self.shortCutNum) {
                    case 0:
                    {
                        [self performSelector:@selector(typeSelected:) withObject:self.workButton];
                        break;
                    }
                    case 1:
                    {
                        [self performSelector:@selector(typeSelected:) withObject:self.playButton];
                        break;
                    }
                    case 2:
                    {
                        [self performSelector:@selector(typeSelected:) withObject:self.sportButton];
                        break;
                    }
                    case 3:
                    {
                        [self performSelector:@selector(typeSelected:) withObject:self.cookButton];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"unwind"] && self.isSucceeded == YES)
    {
    [TSMessage showNotificationInViewController:[segue destinationViewController]
                                          title:@"Succeed !"
                                       subtitle:@"Task Has Been Added Succesfully"
                                          image:nil
                                           type:TSMessageNotificationTypeSuccess
                                       duration:0.8
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
    }

}


@end
