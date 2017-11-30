//
//  HNMicroHeadlineModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/29.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMicroHeadlineModel.h"
#import <MJExtension/MJExtension.h>
@implementation HNMicroHeadlineImageModel

@end
@implementation HNMicroHeadlineUserModel

@end
@implementation HNMicroHeadlineDetailModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"large_image_list" : @"HNMicroHeadlineImageModel",
             @"thumb_image_list" : @"HNMicroHeadlineImageModel",
             @"ugc_cut_image_list" : @"HNMicroHeadlineImageModel",
             };
}
@end

@implementation HNMicroHeadlineSummaryModel
- (HNMicroHeadlineDetailModel *)detialModel {
    if (_detialModel) {
        return _detialModel;
    }
    NSData *data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    HNMicroHeadlineDetailModel *model = [[HNMicroHeadlineDetailModel alloc]init];
    [model mj_setKeyValues:dic];
    _detialModel = model;
    return _detialModel;
}
@end

@implementation HNMicroHeadlineModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"HNMicroHeadlineSummaryModel",
             };
}
@end
