//
//  HNVideoTitleViewModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/22.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoTitleViewModel.h"
#import "HNTitleRequest.h"
#import "HNVideoTitleModel.h"

@implementation HNVideoTitleViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titlesCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HNTitleRequest *request = [HNTitleRequest netWorkModelWithURLString:[HNURLManager videoTitlesURLString] isPost:NO];
                request.iid = HN_IID;
                request.device_id = HN_DEVICE_ID;
                [request sendRequestWithSuccess:^(id response) {
                    NSDictionary *responseDic = (NSDictionary *)response;
                    NSMutableArray *models = [NSMutableArray array];
                    if ([responseDic[@"message"] isEqualToString:@"success"]) {
                        NSArray *dicArr = responseDic[@"data"];
                        for (int i = 0; i < [dicArr count]; i++) {
                            HNVideoTitleModel *model = [[HNVideoTitleModel new] mj_setKeyValues:dicArr[i]];
                            [models addObject:model];
                        }
                        [subscriber sendNext:models];
                        [subscriber sendCompleted];
                    }else {
                        [MBProgressHUD showError:responseDic[@"message"] toView:nil];
                    }
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD showError:error.localizedDescription toView:nil];
                }];
                return nil;
            }];
        }];
    }
    return self;
}

@end
