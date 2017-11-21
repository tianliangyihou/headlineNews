//
//  HNHomeVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeVC.h"
#import "HNDetailVC.h"
#import "UIButton+EX.h"
@interface HNHomeVC ()<WMPageControllerDataSource,WMPageControllerDelegate>

@end

@implementation HNHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    HNNavigationBar *bar = [self showCustomNavBar];
    [bar.searchSubjuct subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self.view addSubview:bar];
    self.delegate = self;
    self.dataSource = self;
    self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 10;
    UIButton *addBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"add_channel_titlbar_thin_new_16x16_"],UIControlStateNormal).backgroundImage([UIImage imageNamed:@"shadow_add_titlebar_new3_52x36_"],UIControlStateNormal);
    addBtn.frame = CGRectMake(HN_SCREEN_WIDTH - 52, 0,52,35);
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.menuView addSubview:addBtn];
    [[addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了按钮");
    }];
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 11;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
  
    return [HNDetailVC new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 5) {
        return @"火山小视频";
    }
    return @"推荐";
}


@end
