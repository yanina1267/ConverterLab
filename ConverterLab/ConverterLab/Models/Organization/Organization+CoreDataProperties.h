//
//  Organization+CoreDataProperties.h
//  ConverterLab
//
//  Created by Yana Stepanova on 5/3/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Organization.h"

NS_ASSUME_NONNULL_BEGIN

@interface Organization (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *region;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSSet<Currency *> *currencies;

@end

@interface Organization (CoreDataGeneratedAccessors)

- (void)addCurrenciesObject:(Currency *)value;
- (void)removeCurrenciesObject:(Currency *)value;
- (void)addCurrencies:(NSSet<Currency *> *)values;
- (void)removeCurrencies:(NSSet<Currency *> *)values;

@end

NS_ASSUME_NONNULL_END
