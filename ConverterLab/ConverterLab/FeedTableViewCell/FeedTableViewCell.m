//
//  FeedTableViewCell.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/3/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "LinedButton.h"

#import "Organization.h"

@interface FeedTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) Organization *organization;

@end

@implementation FeedTableViewCell

#pragma mark - IBActions

- (IBAction)openLinkPressed:(LinedButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(feedCell:didAskToOpenLink:)]) {
        [self.delegate feedCell:self didAskToOpenLink:self.organization.link];
    }
}

- (IBAction)openMapPressed:(LinedButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(feedCell:didAskToOpenMapForAddress:)]) {
        [self.delegate feedCell:self didAskToOpenMapForAddress:[self.organization fullAddress]];
    }
}

- (IBAction)callPressed:(LinedButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(feedCell:didAskToCallToNumber:)]) {
        [self.delegate feedCell:self didAskToCallToNumber:self.organization.phone];
    }
}

- (IBAction)detailPressed:(LinedButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(feedCell:didAskToShowDetailsForOrganization:)]) {
        [self.delegate feedCell:self didAskToShowDetailsForOrganization:self.organization];
    }
}

#pragma mark - Public

- (void)configureCellWithOrganization:(Organization *)organization
{
    self.organization = organization;
    self.titleLabel.text = organization.title;
    self.regionLabel.text = organization.region;
    self.cityLabel.text = organization.city;
    self.phoneLabel.text = [NSString stringWithFormat:@"Тел.: %@", organization.phone];
    self.addressLabel.text = [NSString stringWithFormat:@"Адрес: %@", organization.address];
}

@end
