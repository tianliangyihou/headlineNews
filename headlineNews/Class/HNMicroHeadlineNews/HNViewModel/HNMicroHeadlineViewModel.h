//
//  HNMicroHeadlineViewModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/29.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNBaseViewModel.h"
#import "HNMicroHeadlineModel.h"
#import "HNDiskCacheHelper.h"
@interface HNMicroHeadlineViewModel : HNBaseViewModel

@property (nonatomic , strong)RACCommand *microHeadlineCommand;

- (NSArray *)cacheLayouts;
@end
