//
//  TaskCell.h
//  timeWiser
//
//  Created by Liu Zhe on 4/4/14.
//  Copyright (c) 2014 CDFLS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13Checkbox.h"

@interface TaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet M13Checkbox *checkBox;
@end
