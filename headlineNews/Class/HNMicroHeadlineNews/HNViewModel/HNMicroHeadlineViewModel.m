
//
//  HNMicroHeadlineViewModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/29.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMicroHeadlineViewModel.h"
#import "HNMicroHeadlineRequest.h"
#import "HNMicroLayout.h"
#import <YYText/NSAttributedString+YYText.h>
#define cacheKey [NSString stringWithFormat:@"microHeadline%@",HNURLManager.microHeadlineURLString]
/**
 缓存策略:
    1.先去数据库取数据
    2.显示
    3 网络请求
    4 请求完成 --> 刷新数据
 */
@interface HNMicroHeadlineViewModel ()

@property (nonatomic , strong)NSMutableArray *datas;

@end

@implementation HNMicroHeadlineViewModel

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}

- (NSArray *)cacheLayouts {
    NSArray *layouts =  (NSArray *)[[HNDiskCacheHelper defaultHelper] objectForKey:cacheKey];
    for (HNMicroLayout *layout in layouts) {
        layout.hn_content = (NSMutableAttributedString *)[NSAttributedString yy_unarchiveFromData:layout.hn_content_data];
    }
    return layouts;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        [[HNDiskCacheHelper defaultHelper] setMaxArrayCount:9 forKey:cacheKey];
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
        // --> 复杂的模型处理应该放在异步
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            HNMicroHeadlineModel *model = [[HNMicroHeadlineModel alloc]init];
            [model mj_setKeyValues:response];
            [model.data makeObjectsPerformSelector:@selector(detialModel)];
            NSMutableArray *layouts = [[NSMutableArray alloc]init];
            [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HNMicroHeadlineSummaryModel *model = (HNMicroHeadlineSummaryModel *)obj;
                HNMicroLayout *layout = [[HNMicroLayout alloc]initWithMicroHeadlineModel:model];
                [layouts addObject:layout];
            }];
            HN_ASYN_GET_MAIN(
                             if ([model.message isEqualToString:@"success"]) {
                                 [self setCacheLayouts:layouts withRefresh:input];
                                 [subscriber sendNext:layouts];
                                 [subscriber sendCompleted];
                             }else {
                                 [MBProgressHUD showError:HN_ERROR_SERVER toView:nil];
                             }
                             );
        });
    } failure:^(NSError *error) {
        // do something
        [subscriber sendError:error];
    }];
}

- (void)setCacheLayouts:(NSArray *)layouts withRefresh:(id)isRefresh{

    if ([isRefresh boolValue]) {
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:layouts];
    }else {
        [self.datas addObjectsFromArray:layouts];
    }
    [[HNDiskCacheHelper defaultHelper] setObject:self.datas forKey:cacheKey withBlock:nil];
}

@end
