//
//  LBNetWorkBaseModel.m
//  MVVM&Rac
//
//  Created by dengweihao on 2017/11/1.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNNetWorkBaseModel.h"
#import <MJExtension/MJExtension.h>
@implementation HNNetWorkBaseModel

+ (instancetype)netWorkModelWithURLString:(NSString *)urlString isPost:(BOOL)isPost {
    HNNetWorkBaseModel *model = [[self alloc]init];
    model.isPost = isPost;
    model.urlString = urlString;
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isPost = YES;
        _extraParamters = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)sendRequest {
    [self sendRequestWithSuccess:nil failure:nil];
}

- (void)sendRequestWithSuccess:(SuccessHandle)success failure:(failureHandle)failure {
    if (self.urlString.length == 0 || !self.urlString) {
        return;
    }
    NSMutableDictionary *params = [self params];
    if (self.isPost) {
        [HNNetWorkManager postRequestWithURLString:self.urlString parameters:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }else {
        [HNNetWorkManager getRequestWithURLString:self.urlString parameters:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}


// 公共参数
- (NSMutableDictionary *)params {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addEntriesFromDictionary:self.extraParamters];
    [params addEntriesFromDictionary:self.mj_keyValues];
    
    if ([params.allKeys containsObject:@"isPost"]) {
        [params removeObjectForKey:@"isPost"];
    }
    if ([params.allKeys containsObject:@"urlString"]) {
        [params removeObjectForKey:@"urlString"];
    }
    if ([params.allKeys containsObject:@"extraParamters"]) {
        [params removeObjectForKey:@"extraParamters"];
    }
    for (id key in params.allKeys) {
        id obj = [params objectForKey:key];
        if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
            [params removeObjectForKey:key];
        }
    }
    return params;
}


- (NSString *)description {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self params] options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
@end
