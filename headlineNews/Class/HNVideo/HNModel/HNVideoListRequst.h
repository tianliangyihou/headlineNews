//
//  HNVideoListRequst.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/22.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNNetWorkBaseModel.h"

@interface HNVideoListRequst : HNNetWorkBaseModel
@property (nonatomic , copy)NSString *category;
@property (nonatomic , copy)NSString *device_id;
@property (nonatomic , copy)NSString *iid;
@property (nonatomic , copy)NSString *device_platform;
@property (nonatomic , copy)NSString *version_code;

@end
