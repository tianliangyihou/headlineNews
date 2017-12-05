
//
//  HNMicroHeadlineViewModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/29.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMicroHeadlineViewModel.h"
#import "HNMicroHeadlineRequest.h"
#define cacheKey [NSString stringWithFormat:@"microHeadline%@",HNURLManager.microHeadlineURLString]
/**
 缓存策略:
    1.先去数据库取数据
    2.显示
    3 网络请求
    4 请求完成 --> 刷新数据
 */
@interface HNMicroHeadlineViewModel ()

@property (nonatomic , strong)HNMicroHeadlineModel *cacheModel;

@property (nonatomic , strong)NSMutableArray *datas;

@property (nonatomic , strong)YYCache *cache;
@end

@implementation HNMicroHeadlineViewModel

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}

- (NSArray *)cacheModels {
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    NSArray *models =  (NSArray *)[self.cache objectForKey:cacheKey];
    for (int i = 0 ; i < models.count; i++) {
        HNMicroHeadlineModel *model = models[i];
        [datas addObjectsFromArray:model.data];
    }
    return datas;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [YYCache cacheWithName:@"HN_Micro"];
        @weakify(self);
        _microHeadlineCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               @strongify(self)
                [self requestWithSubscriber:subscriber input:input];
                return nil;
            }];
        }];
    }
    return self;
}

- (void)requestWithSubscriber:(id<RACSubscriber>)subscriber input:(id)input{
    HNMicroHeadlineRequest *request = [HNMicroHeadlineRequest netWorkModelWithURLString:HNURLManager.microHeadlineURLString isPost:NO];
    request.iid = HN_IID;
    request.device_id = HN_DEVICE_ID;
    request.count = @15;
    request.category = @"weitoutiao";
    @weakify(self);
    [request sendRequestWithSuccess:^(id response) {
        @strongify(self);
        HNMicroHeadlineModel *model = [[HNMicroHeadlineModel alloc]init];
        [model mj_setKeyValues:response];
        [model.data makeObjectsPerformSelector:@selector(detialModel)];
        if ([model.message isEqualToString:@"success"]) {
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        }else {
            [MBProgressHUD showError:HN_ERROR_SERVER toView:nil];
        }
        [self setCacheModel:model withRefresh:input];
    } failure:^(NSError *error) {
        // do something
        [subscriber sendError:error];
    }];
}

- (void)setCacheModel:(HNMicroHeadlineModel *)cacheModel withRefresh:(id)isRefresh{
    _cacheModel = cacheModel;
    if ([isRefresh boolValue]) {
        [self.datas removeAllObjects];
        [self.datas addObject:cacheModel];
    }else {
        [self.datas addObject:cacheModel];
    }
    [self.cache setObject:self.datas forKey:cacheKey];
}

@end
