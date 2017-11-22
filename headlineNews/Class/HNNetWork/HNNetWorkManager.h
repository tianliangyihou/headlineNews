//
//  LBNetWorkManager.h
//  MVVM&Rac
//
//  Created by dengweihao on 2017/11/1.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessHandle)(id response);
typedef void(^failureHandle)(NSError *error);
@interface HNNetWorkManager : NSObject

+ (NSURLSessionDataTask *)postRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessHandle)success failure:(failureHandle)failure;

+ (NSURLSessionDataTask *)getRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessHandle)success failure:(failureHandle)failure;

@end
