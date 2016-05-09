//
//  NetworkManager.h
//  Lesson34
//
//  Created by Yana Stepanova on 4/22/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

- (instancetype)initWithBaseURLString:(NSString *)url;
- (void)getDataWithComplitionHandler:(void(^)(NSDictionary *response))completionHandler;

@end
