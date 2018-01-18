


//
//  HNHomeNewsCellViewModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/28.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeNewsCellViewModel.h"
#import "HNHomeNewsRequest.h"
#import "HNHomeNewsModel.h"
#import "HNHomeJokeModel.h"
#import "HNVideoListModel.h"
@implementation HNHomeNewsCellViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _newsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                HNHomeNewsRequest *request = [HNHomeNewsRequest netWorkModelWithURLString:HNURLManager.homeListURLString isPost:NO];
                request.device_id = HN_DEVICE_ID;
                request.iid = HN_IID;
                request.version_code = @"6.2.7";
                request.device_platform = @"iphone";
                request.category = input;
                [request sendRequestWithSuccess:^(id response) {
                    NSDictionary *responseDic = (NSDictionary *)response;
                    if ([input isEqualToString:@"essay_joke"]) {
                        HNHomeJokeModel *model = [[HNHomeJokeModel alloc]init];
                        [model mj_setKeyValues:responseDic];
                        [model.data makeObjectsPerformSelector:@selector(infoModel)];
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
                    }else if ([input isEqualToString:@"video"]) {
                        NSArray *dataArr = responseDic[@"data"];
                        NSMutableArray *models = [[NSMutableArray alloc]init];
                        for (int i = 0 ; i < dataArr.count; i++) {
                            HNVideoListModel *model = [[[HNVideoListModel alloc]init] mj_setKeyValues:dataArr[i]];
                            [[model videoModel] videoInfoModel];
                            [models addObject:model];
                        }
                        [subscriber sendNext:models];
                        [subscriber sendCompleted];
                    }else {
                        HNHomeNewsModel *model = [[HNHomeNewsModel alloc]init];
                        [model mj_setKeyValues:responseDic];
                        [model.data makeObjectsPerformSelector:@selector(infoModel)];
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
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
