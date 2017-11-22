//
//  LBNetWorkManager.m
//  MVVM&Rac
//
//  Created by dengweihao on 2017/11/1.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNNetWorkManager.h"
#import "MBProgressHUD+Add.h"
#define request_timeOut_code -1001
#define request_network_disconnection_code -1009

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
        [self showNetWorkError:error];
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
        [self showNetWorkError:error];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)showNetWorkError:(NSError *)error {
    if (error.code == request_timeOut_code) {
        [MBProgressHUD showError:@"请求超时" toView:nil];
    }else if (error.code == request_network_disconnection_code) {
        [MBProgressHUD showError:@"无法连接网络" toView:nil];
    }else {
        NSString *errMsg = [NSString stringWithFormat:@"获取数据错误o(TωT)o(%ld)",(long)error.code];
        [MBProgressHUD showError:errMsg toView:nil];
    }
}
@end
