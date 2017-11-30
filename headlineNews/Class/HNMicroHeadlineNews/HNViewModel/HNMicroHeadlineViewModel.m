
//
//  HNMicroHeadlineViewModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/29.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMicroHeadlineViewModel.h"
#import "HNMicroHeadlineRequest.h"
#import "HNMicroHeadlineModel.h"
@implementation HNMicroHeadlineViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _microHeadlineCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HNMicroHeadlineRequest *request = [HNMicroHeadlineRequest netWorkModelWithURLString:HNURLManager.microHeadlineURLString isPost:NO];
                request.iid = HN_IID;
                request.device_id = HN_DEVICE_ID;
                request.count = input;
                request.category = @"weitoutiao";
                [request sendRequestWithSuccess:^(id response) {
                    HNMicroHeadlineModel *model = [[HNMicroHeadlineModel alloc]init];
                    [model mj_setKeyValues:response];
                    [model.data makeObjectsPerformSelector:@selector(detialModel)];
                    if ([model.message isEqualToString:@"success"]) {
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
                    }else {
                        [MBProgressHUD showError:HN_ERROR_SERVER toView:nil];
                    }
                } failure:^(NSError *error) {
                   // do something
                }];
                return nil;
            }];
        }];
    }
    return self;
}
@end
