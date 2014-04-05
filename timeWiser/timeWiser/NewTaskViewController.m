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

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface NewTaskViewController ()
@property (strong, nonatomic) JVFloatLabeledTextField *titleField;
@property (strong, nonatomic) JVFloatLabeledTextView *descriptionField;
@property (nonatomic) NSInteger setMin;
@property (nonatomic) NSInteger setHr;
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
    UIColor *redColor = [UIColor colorWithRed:245.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    UIColor *blueColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:29.0/255.0 green:207.0/255.0 blue:0.0 alpha:1.0];
    
    SAMultisectorSector *sector1 = [SAMultisectorSector sectorWithColor:redColor maxValue:16.0];
    SAMultisectorSector *hours = [SAMultisectorSector sectorWithColor:blueColor maxValue:23.0];
    SAMultisectorSector *minutes = [SAMultisectorSector sectorWithColor:greenColor maxValue:60.0];
    
    sector1.tag = 0;
    hours.tag = 1;
    minutes.tag = 2;
    
    //sector1.endValue = 1.0;
    //sector1.startValue = 0.0;
    hours.endValue = 1.0;
    hours.startValue = 0.0;
    minutes.startValue = 0.0;
    minutes.endValue = 1.0;
    
    self.timeSelector.sectorsRadius = 60.0f;
    self.timeSelector.minCircleMarkerRadius = 5.0f;
    self.timeSelector.maxCircleMarkerRadius = 10.0f;
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
    [self updateDataView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height + 30.0f;
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    if (!self.titleField)
    {
    self.titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, topOffset, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    }
    self.titleField.placeholder = NSLocalizedString(@"Title", @"");
    self.titleField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.titleField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
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
    
    /*JVFloatLabeledTextField *priceField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, div1.frame.origin.y + div1.frame.size.height, 80.0f, kJVFieldHeight)];
    priceField.placeholder = NSLocalizedString(@"Price", @"");
    priceField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    priceField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    priceField.floatingLabelTextColor = floatingLabelColor;
    priceField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:priceField];
    
    UIView *div2 = [UIView new];
    div2.frame = CGRectMake(kJVFieldHMargin + priceField.frame.size.width,
                            titleField.frame.origin.y + titleField.frame.size.height,
                            1.0f, kJVFieldHeight);
    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div2];
    
    JVFloatLabeledTextField *locationField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                              CGRectMake(kJVFieldHMargin + kJVFieldHMargin + priceField.frame.size.width + 1.0f,
                                                         div1.frame.origin.y + div1.frame.size.height,
                                                         self.view.frame.size.width - 3*kJVFieldHMargin - priceField.frame.size.width - 1.0f,
                                                         kJVFieldHeight)];
    locationField.placeholder = NSLocalizedString(@"Specific Location (optional)", @"");
    locationField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    locationField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    locationField.floatingLabelTextColor = floatingLabelColor;
    locationField.backgroundColor = [UIColor clearColor];
    locationField.opaque = NO;
    [self.view addSubview:locationField];
    
    */
    if (!self.descriptionField)
    {
    self.descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
    self.descriptionField.frame = CGRectMake(kJVFieldHMargin - self.descriptionField.textContainer.lineFragmentPadding,
                                        div1.frame.origin.y + div1.frame.size.height,
                                        self.view.frame.size.width - 2*kJVFieldHMargin + self.descriptionField.textContainer.lineFragmentPadding,
                                        kJVFieldHeight * 2);
    }
    self.descriptionField.placeholder = NSLocalizedString(@"Description", @"");
    self.descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.descriptionField.floatingLabelTextColor = floatingLabelColor;
    self.descriptionField.backgroundColor = [UIColor clearColor];
    self.descriptionField.opaque = NO;
    [self.view addSubview:self.descriptionField];
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(kJVFieldHMargin, self.descriptionField.frame.origin.y + self.descriptionField.frame.size.height,
                            self.view.frame.size.width - 2*kJVFieldHMargin, 1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div3];
    //set delegate
    self.titleField.delegate = self;
    //priceField.delegate = self;
    //locationField.delegate = self;
    [self setupDesign];
    [self setupTimeSelector];
    
    //[titleField becomeFirstResponder];
}
- (IBAction)addTask:(id)sender {
    if ([self.titleField.text  isEqualToString:@""])
    {
        [self.titleField becomeFirstResponder];
        return;
    }
    if ([self.descriptionField.text isEqualToString:@""])
    {
        [self.descriptionField becomeFirstResponder];
        return;
    }
    self.setMin = [self.minutesLabel.text intValue];
    self.setHr = [self.hoursLabel.text intValue];
    CDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newTask;
    newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    [newTask setValue:[NSNumber numberWithInt:(int)self.setMin] forKey:@"minutes"];
    [newTask setValue:[NSNumber numberWithInt:(int)self.setHr]  forKey:@"hours"];
    [newTask setValue:self.titleField.text forKey:@"title"];
    [newTask setValue:self.descriptionField.text forKey:@"details"];
    NSError *error;
    [context save:&error];
    [self performSegueWithIdentifier:@"unwind" sender:sender];
}
- (IBAction)cancelCreation:(id)sender {
    [self performSegueWithIdentifier:@"unwind" sender:sender];
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
