//
//  Currency+CoreDataProperties.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/3/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Currency.h"
@class Organization;

NS_ASSUME_NONNULL_BEGIN

@interface Currency (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *isoCode;
@property (nullable, nonatomic, retain) NSString *ask;
@property (nullable, nonatomic, retain) NSString *bid;
@property (nullable, nonatomic, retain) Organization *organization;

@end

NS_ASSUME_NONNULL_END
