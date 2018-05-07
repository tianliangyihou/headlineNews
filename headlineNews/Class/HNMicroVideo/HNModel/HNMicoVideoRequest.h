//
//  HNMicoVideoRequest.h
//  headlineNews
//
//  Created by dengweihao on 2018/4/10.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "HNNetWorkBaseModel.h"

@interface HNMicoVideoRequest : HNNetWorkBaseModel
@property (nonatomic , copy)NSString * device_id;
@property (nonatomic , assign)int count;
@property (nonatomic , assign)int list_count;
@property (nonatomic , copy)NSString *category;
@property (nonatomic , assign)NSTimeInterval min_behot_time;
@property (nonatomic , assign)int strict;
@property (nonatomic , assign)int detail;
@property (nonatomic , assign)int refresh_reason;
@property (nonatomic , copy)NSString *tt_from;
@property (nonatomic , copy)NSString * iid;


@end
