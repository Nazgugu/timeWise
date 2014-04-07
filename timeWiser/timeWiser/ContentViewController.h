//
//  ContentViewController.h
//  timeWiser
//
//  Created by Liu Zhe on 3/31/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRoundProgressCounterView.h"

@interface ContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet SFRoundProgressCounterView *timeCounter;
@property (strong, nonatomic) NSString *labelString;
@property (nonatomic, strong, readwrite) NSArray* intervals;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) UIColor* bgColor;
@end
