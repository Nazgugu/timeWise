//
//  NewTaskViewController.h
//  timeWiser
//
//  Created by Liu Zhe on 4/2/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMultisectorControl.h"

@interface NewTaskViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet SAMultisectorControl *timeSelector;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;

@end
