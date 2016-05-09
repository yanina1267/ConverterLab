//
//  FeedTableViewCell.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/3/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Organization;
@class FeedTableViewCell;

@protocol FeedTableViewCellDelegate <NSObject>

- (void)feedCell:(FeedTableViewCell *)cell didAskToOpenLink:(NSString *)link;
- (void)feedCell:(FeedTableViewCell *)cell didAskToOpenMapForAddress:(NSString *)address;
- (void)feedCell:(FeedTableViewCell *)cell didAskToCallToNumber:(NSString *)number;
- (void)feedCell:(FeedTableViewCell *)cell didAskToShowDetailsForOrganization:(Organization *)organization;

@end

@interface FeedTableViewCell : UITableViewCell

@property (weak, nonatomic) id<FeedTableViewCellDelegate> delegate;

- (void)configureCellWithOrganization:(Organization *)organization;

@end

