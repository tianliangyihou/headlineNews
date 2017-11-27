//
//  HNDetailVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/19.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNDetailVC.h"
#import "HNHomeVC.h"
@interface HNDetailVC ()

@end

@implementation HNDetailVC

- (void)dealloc {
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *view = [[UILabel alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    view.textAlignment = NSTextAlignmentCenter;
    view.backgroundColor = [UIColor redColor];
    view.text = self.titleName;

    
}


@end
