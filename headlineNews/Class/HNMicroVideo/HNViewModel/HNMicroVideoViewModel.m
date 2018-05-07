//
//  HNMicroVideoViewModel.m
//  headlineNews
//
//  Created by dengweihao on 2018/4/10.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "HNMicroVideoViewModel.h"
#import "HNMicoVideoRequest.h"
@implementation HNMicroVideoViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _microVideoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HNMicoVideoRequest *request = [HNMicoVideoRequest netWorkModelWithURLString:[HNURLManager microVideoURLString] isPost:NO];
                request.device_id = HN_DEVICE_ID;
                request.count = 20;
                request.list_count = 15;
                request.category = @"hotsoon_video";
                request.min_behot_time = [[NSDate date] timeIntervalSince1970];
                request.strict = 0;
                request.detail = 1;
                request.refresh_reason = 1;
                request.tt_from = @"enter_auto";
                request.iid = HN_IID;
                [request sendRequestWithSuccess:^(id response) {
                    NSDictionary *responseDic = (NSDictionary *)response;
                    responseDic = responseDic[@"data"];
                    NSMutableArray *models = [NSMutableArray array];
                    if (responseDic.count > 0) {
                        [subscriber sendNext:models];
                        [subscriber sendCompleted];
                    }else {
                        [MBProgressHUD showError: HN_ERROR_SERVER toView:nil];
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
