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
}

- (void)rightItemAction {
    [self.navigationController pushViewController:[HNDetailVC new] animated:YES];
}

@end
