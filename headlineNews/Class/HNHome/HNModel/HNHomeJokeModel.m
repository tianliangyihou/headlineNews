//
//  HNHomeJokeModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/5.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeJokeModel.h"
#import <MJExtension/MJExtension.h>
@implementation HNHomeJokeInfoModel


@end

@implementation HNHomeJokeSummaryModel
- (HNHomeJokeInfoModel *)infoModel {
    if (_infoModel) {
        return _infoModel;
    }
    NSData *data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    HNHomeJokeInfoModel *model = [[HNHomeJokeInfoModel alloc]init];
    [model mj_setKeyValues:dic];
    _infoModel = model;
    return model;
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"starBtnSelcetd",
             @"hateBtnSelcetd",
             @"collectionSelcetd"];
}

@end

@implementation HNHomeJokeModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"HNHomeJokeSummaryModel"
             };
}
@end
