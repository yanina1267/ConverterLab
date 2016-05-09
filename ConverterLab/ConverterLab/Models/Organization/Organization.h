//
//  Organization.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/3/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Currency;

NS_ASSUME_NONNULL_BEGIN

@interface Organization : NSManagedObject

- (NSString *)fullAddress;

@end

NS_ASSUME_NONNULL_END

#import "Organization+CoreDataProperties.h"
