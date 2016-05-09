//
//  Organization.m
//  ConverterLab
//
//  Created by Yana Stepanova on 5/3/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "Organization.h"
#import "Currency.h"

@implementation Organization

- (NSString *)fullAddress
{
    return [NSString stringWithFormat:@"%@, %@", self.city, self.address];
}

@end
