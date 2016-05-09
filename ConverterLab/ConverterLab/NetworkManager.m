//
//  NetworkManager.m
//  Lesson34
//
//  Created by Yana Stepanova on 4/22/16.
//  Copyright © 2016 Yana Stepanova. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>


@interface NetworkManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation NetworkManager

#pragma mark - Lifecycle

- (instancetype)initWithBaseURLString:(NSString *)url
{
    if (self = [super init]) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:url] sessionConfiguration:sessionConfiguration];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
}

#pragma mark - Public

- (void)getDataWithComplitionHandler:(void(^)(NSDictionary *response))completionHandler
{
    [self.sessionManager GET:self.sessionManager.baseURL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {

        if (completionHandler) {
            completionHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error loading from server: %@", error);
    }];
}

@end
