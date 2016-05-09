//
//  ShareView.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/9/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "ShareView.h"
#import "UIColor+ApplicationColors.h"
#import "ShareViewCell.h"
#import "Currency.h"
#import "Organization.h"

@interface ShareView () <UITableViewDataSource>

@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) UIView *parentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *regionLabel;
@property (strong, nonatomic) UILabel *cityLabel;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) Organization *organization;
@property (strong, nonatomic) NSArray<Currency *> *currencies;

@end

@implementation ShareView

#pragma mark - Life cycle

- (instancetype)initWithParentView:(UIView *)parentView organization:(Organization *)organization
{
    self = [super init];
    if (self) {
        _parentView = parentView;
        _organization = organization;
        _currencies = organization.currencies.allObjects;
        
        self.backgroundColor = [UIColor darkGreenBackgroundColor];
        [_parentView addSubview:self];
        [self addConstraintsOnParentView];
        [self createShareView];
        [self addLabels];
        [self addShareButton];
        [self addTableView];
        self.alpha = 0.0;
        [self showAnimated];
    }
    return self;
}

- (void)removeFromParentViewWithCompletion:(void(^)())completion
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - UIViewAnimations

- (void)showAnimated
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currencies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShareViewCellIdentifier forIndexPath:indexPath];
    [cell configureCellWithCurrency:self.currencies[indexPath.row]];
    return cell;
}

#pragma mark - Private

- (void)addConstraintsOnParentView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self.parentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.parentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}


- (void)createShareView
{
    self.shareView = [UIView new];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.shareView];
    self.shareView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.65 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)addTableView
{
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.shareView addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shareView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.tableView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0
                                                                   constant:0.0],
                                     [NSLayoutConstraint constraintWithItem:self.tableView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:0.0],
                                     [NSLayoutConstraint constraintWithItem:self.tableView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.cityLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:20.0],
                                     [NSLayoutConstraint constraintWithItem:self.tableView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareButton
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:-20.0]]];
    
    [self.tableView registerClass:[ShareViewCell class] forCellReuseIdentifier:ShareViewCellIdentifier];
}




- (void)addLabels
{
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textColor = [UIColor darkestGreenColor];
    self.titleLabel.text = self.organization.title;
    [self.shareView addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shareView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0 constant:20.0],
                                     [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:20.0],
                                     [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:20.0]]];
    

    self.regionLabel = [UILabel new];
    self.regionLabel.font = [UIFont systemFontOfSize:15];
    self.regionLabel.textColor = [UIColor darkGreenColor];
    self.regionLabel.text = self.organization.region;
    [self.shareView addSubview:self.regionLabel];
    self.regionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shareView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.regionLabel
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0 constant:20.0],
                                     [NSLayoutConstraint constraintWithItem:self.regionLabel
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:20.0],
                                     [NSLayoutConstraint constraintWithItem:self.regionLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.titleLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:8.0]]];
    
    self.cityLabel = [UILabel new];
    self.cityLabel.font = [UIFont systemFontOfSize:15];
    self.cityLabel.textColor = [UIColor darkGreenColor];
    self.cityLabel.text = self.organization.city;
    [self.shareView addSubview:self.cityLabel];
    self.cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shareView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.cityLabel
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0 constant:20.0],
                                     [NSLayoutConstraint constraintWithItem:self.cityLabel
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:20.0],
                                     [NSLayoutConstraint constraintWithItem:self.cityLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.regionLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:8.0]]];
    
}

- (void)addShareButton
{
    self.shareButton = [UIButton new];
    self.shareButton.backgroundColor = [UIColor lightGrayBackgroundColor];
    [self.shareButton setTitle:@"SHARE" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor lightPinkColor] forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.shareView addSubview:self.shareButton];
    self.shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shareView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.shareButton
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0 constant:0.0],
                                     [NSLayoutConstraint constraintWithItem:self.shareButton
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:0.0],
                                     [NSLayoutConstraint constraintWithItem:self.shareButton
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.shareView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0]]];
    
    [self.shareButton addConstraint:[NSLayoutConstraint constraintWithItem:self.shareButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:44]];
    
    [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareButtonPressed
{
    if (self.shareBlock) {
        self.shareBlock();
    }
}

@end
