//
//  HNMicroHeadlineRequest.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/29.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNNetWorkBaseModel.h"

@interface HNMicroHeadlineRequest : HNNetWorkBaseModel
@property (nonatomic , copy)NSString *device_id;
@property (nonatomic , copy)NSString *iid;
@property (nonatomic , copy)NSString *category;
@property (nonatomic , strong)NSNumber *count;
@end
