//
//  LPPopupListView.m
//
//  Created by Luka Penger on 27/03/14.
//  Copyright (c) 2014 Luka Penger. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.
//
// Copyright (c) 2014 Luka Penger
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LPPopupListView.h"
#import "UIColor+MLPFlatColors.h"

@interface LPPopupListView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayList;
@property (nonatomic, strong) NSString *navigationBarTitle;
@property (nonatomic, assign) BOOL isMultipleSelection;

@end


@implementation LPPopupListView


#define navigationBarHeight 44.0f
#define separatorLineHeight 1.0f
#define closeButtonWidth 44.0f
#define navigationBarTitlePadding 12.0f
#define animationsDuration 0.45f

static BOOL isShown = false;


#pragma mark - Lifecycle

- (id)initWithTitle:(NSString *)title list:(NSArray *)list selectedList:(NSArray *)selectedItemsList point:(CGPoint)point size:(CGSize)size multipleSelection:(BOOL)multipleSelection
{
    CGRect frame = CGRectMake(point.x, point.y,size.width,size.height);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor = [[UIColor flatBlueColor] colorWithAlphaComponent:0.7f];
        
        self.cellHighlightColor = [[UIColor flatDarkBlueColor] colorWithAlphaComponent:0.5f];
        
        self.navigationBarTitle = title;
        self.arrayList = [NSArray arrayWithArray:list];
        self.selectedList = [NSMutableArray arrayWithArray:selectedItemsList];
        self.isMultipleSelection = multipleSelection;

        self.navigationBarView = [[UIView alloc] init];
        self.navigationBarView.backgroundColor = [[UIColor flatDarkBlueColor] colorWithAlphaComponent:0.4f];
        [self addSubview:self.navigationBarView];

        self.separatorLineView = [[UIView alloc] init];
        self.separatorLineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        [self addSubview:self.separatorLineView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = self.navigationBarTitle;
        self.titleLabel.font = [UIFont fontWithName:@"Avenir Next" size:18.0f];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.navigationBarView addSubview:self.titleLabel];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
        [self.navigationBarView addSubview:self.closeButton];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
    
    self.navigationBarView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, navigationBarHeight);
    
    self.separatorLineView.frame = CGRectMake(0.0f, self.navigationBarView.frame.size.height, self.frame.size.width, separatorLineHeight);
    
    self.closeButton.frame = CGRectMake((self.navigationBarView.frame.size.width-closeButtonWidth), 0.0f, closeButtonWidth, self.navigationBarView.frame.size.height);
    
    self.titleLabel.frame = CGRectMake(navigationBarTitlePadding, 0.0f, (self.navigationBarView.frame.size.width-closeButtonWidth-(navigationBarTitlePadding * 2)), navigationBarHeight);
    
    self.tableView.frame = CGRectMake(0.0f, (navigationBarHeight + separatorLineHeight), self.frame.size.width, (self.frame.size.height-(navigationBarHeight + separatorLineHeight)));
}

- (void)closeButtonClicked:(id)sender
{
    [self hideAnimated:self.closeAnimated];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LPPopupListViewCell";
    
    LPPopupListViewCell *cell = [[LPPopupListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.highlightColor = self.cellHighlightColor;
    cell.textLabel.text = [self.arrayList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.isMultipleSelection) {
        if ([self.selectedList containsObject:[self.arrayList objectAtIndex:indexPath.row]]) {
            cell.rightImageView.image = [UIImage imageNamed:@"checkMark"];
        } else {
            cell.rightImageView.image = nil;
        }
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isMultipleSelection) {
        if ([self.selectedList containsObject:[self.arrayList objectAtIndex:indexPath.row]]) {
            [self.selectedList removeObject:[self.arrayList objectAtIndex:indexPath.row]];
        } else {
            [self.selectedList addObject:[self.arrayList objectAtIndex:indexPath.row]];
        }
        
        [self.tableView reloadData];
    } else {
        isShown = false;
        
        if ([self.delegate respondsToSelector:@selector(popupListView:didSelectedIndex:)]) {
            [self.delegate popupListView:self didSelectedIndex:indexPath.row];
        }
        
        [self hideAnimated:self.closeAnimated];
    }
}

#pragma mark - Instance methods

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    if(!isShown) {
        isShown = true;
        self.closeAnimated = animated;
        
        if(animated) {
            self.alpha = 0.0f;
            [view addSubview:self];
            
            [UIView animateWithDuration:animationsDuration animations:^{
                self.alpha = 1.0f;
            }];
        } else {
            [view addSubview:self];
        }
    }
}

- (void)hideAnimated:(BOOL)animated
{
    if(animated) {
        [UIView animateWithDuration:animationsDuration animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            isShown = false;
            
            if(self.isMultipleSelection) {
                if ([self.delegate respondsToSelector:@selector(popupListViewDidHide:selectedList:)]) {
                    [self.delegate popupListViewDidHide:self selectedList:self.selectedList];
                }
            }
            
            [self removeFromSuperview];
        }];
    } else {
        isShown = false;
        
        if(self.isMultipleSelection) {
            if ([self.delegate respondsToSelector:@selector(popupListViewDidHide:selectedList:)]) {
                [self.delegate popupListViewDidHide:self selectedList:self.selectedList];
            }
        }
        
        [self removeFromSuperview];
    }
}

@end
