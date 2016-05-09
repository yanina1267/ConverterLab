//
//  ShareViewCell.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/9/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Currency;

extern NSString *const ShareViewCellIdentifier;

@interface ShareViewCell : UITableViewCell

- (void)configureCellWithCurrency:(Currency *)currency;

@end
