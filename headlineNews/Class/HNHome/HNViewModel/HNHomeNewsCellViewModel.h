//
//  HNHomeNewsCellViewModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/28.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNBaseViewModel.h"

@interface HNHomeNewsCellViewModel : HNBaseViewModel
@property (nonatomic , strong) RACCommand *newsCommand;
@end
