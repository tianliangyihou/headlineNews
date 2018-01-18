//
//  HNVideoListViewModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/22.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoListViewModel.h"
#import "HNVideoListRequst.h"
#import "HNVideoListViewModel.m"
#import "HNVideoListModel.h"


@implementation HNVideoListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _videoListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HNVideoListRequst *request = [HNVideoListRequst netWorkModelWithURLString:[HNURLManager videoListURLString] isPost:NO];
                request.device_id = HN_DEVICE_ID;
                request.iid = HN_IID;
                request.version_code = @"6.2.7";
                request.device_platform = @"iphone";
                request.category = input;
                [request sendRequestWithSuccess:^(id response) {
                    NSDictionary *responseDic = (NSDictionary *)response;
                    NSArray *dataArr = responseDic[@"data"];
                    NSMutableArray *models = [[NSMutableArray alloc]init];
                    for (int i = 0 ; i < dataArr.count; i++) {
                        HNVideoListModel *model = [[[HNVideoListModel alloc]init] mj_setKeyValues:dataArr[i]];
                        [[model videoModel] videoInfoModel];
                        [models addObject:model];
                    }
                    [subscriber sendNext:models];
                    [subscriber sendCompleted];
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
