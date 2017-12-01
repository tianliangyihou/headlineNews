//
//  LBNetWorkManager.m
//  MVVM&Rac
//
//  Created by dengweihao on 2017/11/1.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNNetWorkManager.h"

static const float timeOut = 10.0;

@interface HNNetWorkManager ()

@end

@implementation HNNetWorkManager

+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeOut;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return manager;
}

+ (NSURLSessionDataTask *)postRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessHandle)success failure:(failureHandle)failure {

    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self.manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (NSURLSessionDataTask *)getRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessHandle)success failure:(failureHandle)failure {
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self.manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
