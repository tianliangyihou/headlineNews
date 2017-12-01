//
//  LBNetWorkBaseModel.h
//  MVVM&Rac
//
//  Created by dengweihao on 2017/11/1.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNNetWorkManager.h"
#import "HNURLManager.h"
@interface HNNetWorkBaseModel : NSObject

@property (nonatomic , copy)NSString *urlString;

@property (nonatomic , assign)BOOL isPost;

@property (nonatomic , assign)BOOL showNetErrorHUD;

@property (nonatomic , strong)NSDictionary *extraParamters;

+ (instancetype)netWorkModelWithURLString:(NSString *)urlString isPost:(BOOL)isPost;
- (void)sendRequest;
- (void)sendRequestWithSuccess:(SuccessHandle)success failure:(failureHandle)failure;

@end
