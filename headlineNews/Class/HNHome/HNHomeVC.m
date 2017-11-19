//
//  HNHomeVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeVC.h"
#import "HNDetailVC.h"
@interface HNHomeVC ()

@end

@implementation HNHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftItemWithText:@"今日头条"];
    [self addRightItemWithText:@"搜索"];
    self.title = @"haha";
}

- (void)rightItemAction {
    [self.navigationController pushViewController:[HNDetailVC new] animated:YES];
}

@end
