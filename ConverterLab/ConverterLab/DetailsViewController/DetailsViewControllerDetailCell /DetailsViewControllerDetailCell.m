//
//  DetailsViewControllerDetailCell.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/8/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "DetailsViewControllerDetailCell.h"

#import "Organization.h"

@interface DetailsViewControllerDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation DetailsViewControllerDetailCell

#pragma mark - Public

- (void)configureCellWithOrganization:(Organization *)organization
{
    self.titleLabel.text = organization.title;
    self.linkLabel.text = [NSString stringWithFormat:@"Ссылка: %@", organization.link];
    self.phoneLabel.text = [NSString stringWithFormat:@"Телефон: %@", organization.phone];
    self.addressLabel.text = [NSString stringWithFormat:@"Адрес: %@", organization.address];
}

@end
