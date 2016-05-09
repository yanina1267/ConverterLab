//
//  ShareViewCell.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/9/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "ShareViewCell.h"
#import "UIColor+ApplicationColors.h"
#import "Currency.h"

NSString *const ShareViewCellIdentifier = @"ShareViewCell";

@interface ShareViewCell ()

@property (strong, nonatomic) UILabel *currencyTitleLabel;
@property (strong, nonatomic) UILabel *currencyValuesLabel;

@end

@implementation ShareViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:ShareViewCellIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addLabels];
    }
    return self;
}

#pragma mark - Private

- (void)addLabels
{
    self.currencyTitleLabel = [UILabel new];
    self.currencyTitleLabel.font = [UIFont systemFontOfSize:20];
    self.currencyTitleLabel.textColor = [UIColor darkPinkColor];
    [self.contentView addSubview:self.currencyTitleLabel];
    self.currencyTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.currencyTitleLabel
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.contentView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0 constant:30.0],
                                     [NSLayoutConstraint constraintWithItem:self.currencyTitleLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.contentView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:8.0],
                                     [NSLayoutConstraint constraintWithItem:self.currencyTitleLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.contentView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:-8.0]]];
    
    self.currencyValuesLabel = [UILabel new];
    self.currencyValuesLabel.font = [UIFont systemFontOfSize:20];
    self.currencyValuesLabel.textColor = [UIColor darkGreenColor];
    [self.contentView addSubview:self.currencyValuesLabel];
    self.currencyValuesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self.currencyValuesLabel
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0 constant:-30.0],
                                       [NSLayoutConstraint constraintWithItem:self.currencyValuesLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:8.0],
                                       [NSLayoutConstraint constraintWithItem:self.currencyValuesLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-8.0]]];
    

}

#pragma mark - Public

- (void)configureCellWithCurrency:(Currency *)currency
{
    self.currencyTitleLabel.text = currency.isoCode;
    self.currencyValuesLabel.text = [NSString stringWithFormat:@"%@/%@", currency.bid, currency.ask];
}

@end
