//
//  HNBaseViewModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/23.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <YYCache/YYCache.h>
#import "MBProgressHUD+Add.h"
#import "HNHeader.h"
#import "HNURLManager.h"

#define HN_ERROR_SERVER @"服务器异常"
@interface HNBaseViewModel : NSObject

- (void)bindView:(UIView *)view;
- (void)bindTableView:(UITableView *)tableView;
@end
