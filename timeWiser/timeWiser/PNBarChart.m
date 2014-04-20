//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNBar.h"

@interface PNBarChart() {
    NSMutableArray* _bars;
    NSMutableArray* _labels;
    NSMutableArray* _timeLabels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;
@end

@implementation PNBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        _showLabel           = YES;
        _barBackgroundColor  = PNLightGrey;
        _labels              = [NSMutableArray array];
        _bars                = [NSMutableArray array];
        _timeLabels          = [NSMutableArray array];
    }

    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];

    _xLabelWidth = (self.frame.size.width - chartMargin*2)/[_yValues count];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    for (NSNumber *value in yLabels) {
        //NSLog(@"number here is %@",value);
        NSInteger valueInt = [value integerValue];
        //NSLog(@"integer is %d",valueInt);
        if (valueInt > max) {
            max = valueInt;
        }

    }

    //Min value for Y label
    if (max < 5) {
        max = 5;
    }

    _yValueMax = (int)max;
}

- (void)setTimeLabel:(NSArray *)timeLabel
{
    [self viewCleanupForCollection:_timeLabels];
    _timeLabel = timeLabel;
    if (_showLabel)
    {
        _xLabelWidth = (self.frame.size.width - chartMargin*2)/[timeLabel count];
    }
    for(int index = 0; index < timeLabel.count; index++)
    {
        PNChartLabel *timeLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin), self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        //NSLog(@"%@",timeLabel.text);
        timeLabel.text = [NSString stringWithFormat:@"%d mins",[[self.timeLabel objectAtIndex:index] intValue]];
        //NSLog(@"here %@",timeLabel.text);
        [_timeLabels addObject:timeLabel];
        [self addSubview:timeLabel];
    }
}

-(void)setXLabels:(NSArray *)xLabels
{
    [self viewCleanupForCollection:_labels];
    _xLabels = xLabels;
    //NSLog(@"I am setting labels");
    if (_showLabel) {
        //NSLog(@"I am here");
        _xLabelWidth = (self.frame.size.width - chartMargin*2)/[xLabels count];

        for(int index = 0; index < xLabels.count; index++)
        {
            //NSLog(@"# of xlables = %d",xLabels.count);
            NSString* labelText = xLabels[index];
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin), self.frame.size.height - 50.0, _xLabelWidth, 20.0)];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            //NSLog(@"this name is: %@",labelText);
            NSString *description = [NSString stringWithFormat:@"%@",labelText];
            //NSLog(@"%d mins",[self.yValues[index] intValue]);
            label.text = description;
            
            
            [_labels addObject:label];
            
            [self addSubview:label];
        }
    }
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
}

-(void)strokeChart
{
    [self viewCleanupForCollection:_bars];
    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 30.0;
    NSInteger index = 0;

    for (NSString * valueString in _yValues) {
        float value = [valueString floatValue];

        float grade = (float)value / (float)_yValueMax;
        PNBar * bar;
        if (_showLabel) {
            bar = [[PNBar alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin + _xLabelWidth * 0.25), self.frame.size.height - chartCavanHeight - 50.0, _xLabelWidth * 0.5, chartCavanHeight)];
        }else{
            bar = [[PNBar alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin + _xLabelWidth * 0.25), self.frame.size.height - chartCavanHeight , _xLabelWidth * 0.6, chartCavanHeight)];
        }
        bar.backgroundColor = _barBackgroundColor;
        bar.barColor = [self barColorAtIndex:index];
        bar.grade = grade;
        [_bars addObject:bar];
        [self addSubview:bar];

        index += 1;
    }
    NSLog(@"number of bars = %lu",(unsigned long)[_bars count]);
    NSLog(@"number of labels = %lu",(unsigned long)[_timeLabel count]);
    NSLog(@"number of xlabels = %lu",(unsigned long)[_labels count]);
    NSLog(@"number of yvalues = %lu",(unsigned long)[self.yValues count]);
}

- (void)viewCleanupForCollection:(NSMutableArray*)array
{
    NSLog(@"I am cleaning up");
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}

#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    } else {
        return self.strokeColor;
    }
}

@end
