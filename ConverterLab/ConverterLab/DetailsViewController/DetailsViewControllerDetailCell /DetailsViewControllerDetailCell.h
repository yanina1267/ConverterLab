//
//  DetailsViewControllerDetailCell.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/8/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Organization;

@interface DetailsViewControllerDetailCell : UITableViewCell

- (void)configureCellWithOrganization:(Organization *)organization;

@end
