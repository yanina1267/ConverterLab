//
//  DetailsViewControllerCurrencyCell.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/8/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "DetailsViewControllerCurrencyCell.h"

#import "Currency.h"

@interface DetailsViewControllerCurrencyCell ()

@property (weak, nonatomic) IBOutlet UILabel *currencyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *askLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation DetailsViewControllerCurrencyCell

#pragma mark - Lifecycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self removeShadow];
}

#pragma mark - Public

- (void)configureCellWithCurrency:(Currency *)currency
{
    self.currencyTitleLabel.text = currency.title;
    self.askLabel.text = currency.ask;
    self.bidLabel.text = currency.bid;
}

- (void)addShadow
{
    self.containerView.layer.shadowRadius = 3.0;
    self.containerView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    self.containerView.layer.shadowOpacity = 0.5;
}

- (void)removeShadow
{
    self.containerView.layer.shadowRadius = 0.0;
    self.containerView.layer.shadowOffset = CGSizeZero;
    self.containerView.layer.shadowOpacity = 0.0;
}

@end
