//
//  HNDetailVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/19.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNDetailVC.h"

@interface HNDetailVC ()

@end

@implementation HNDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftItemWithText:@"quxi"];

}

- (void)viewDidAppear:(BOOL)animated {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, 30, 20)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor redColor];
}

@end
