
//
//  HNHomeTitleViewModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/28.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeTitleViewModel.h"
#import "HNHomeTitleRequest.h"
#import "HNHomeTitleModel.h"
@implementation HNHomeTitleViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titlesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HNHomeTitleRequest *request = [HNHomeTitleRequest netWorkModelWithURLString:HNURLManager.homeTitleURLString isPost:NO];
                request.iid = HN_IID;
                request.device_id = HN_DEVICE_ID;
                request.aid = [input intValue];
                [request sendRequestWithSuccess:^(id response) {
                    NSDictionary *responseDic = (NSDictionary *)response;
                    responseDic = responseDic[@"data"];
                    NSMutableArray *models = [NSMutableArray array];
                    if (responseDic.count > 0) {
                        NSArray *dicArr = responseDic[@"data"];
                        for (int i = 0; i < [dicArr count]; i++) {
                            HNHomeTitleModel *model = [[HNHomeTitleModel new] mj_setKeyValues:dicArr[i]];
                            [models addObject:model];
                        }
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
