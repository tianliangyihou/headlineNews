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
#import "HNChannelView.h"
#import "HNHomeTitleViewModel.h"
#import "HNHomeTitleModel.h"
@interface HNHomeVC ()<WMPageControllerDataSource,WMPageControllerDelegate>

@property (nonatomic , strong)HNHomeTitleViewModel *titleViewModel;

@property (nonatomic , strong)NSArray *models;

@end

@implementation HNHomeVC

- (HNHomeTitleViewModel *)titleViewModel {
    if (!_titleViewModel) {
        _titleViewModel = [[HNHomeTitleViewModel alloc]init];
    }
    return _titleViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HNNavigationBar *bar = [self showCustomNavBar];
    [bar.searchSubjuct subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self configUI];
    @weakify(self)
    [[self.titleViewModel.titlesCommand execute:@13] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.models = x;
        [self reloadData];
        [self configPageVC];
    }];
    
}

#pragma mark - configUI
- (void)configUI {
    self.delegate = self;
    self.dataSource = self;
    self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 10;
}

- (void)configPageVC {
    UIButton *addBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"add_channel_titlbar_thin_new_16x16_"],UIControlStateNormal).backgroundImage([UIImage imageNamed:@"shadow_add_titlebar_new3_52x36_"],UIControlStateNormal);
    addBtn.frame = CGRectMake(HN_SCREEN_WIDTH - 52, 0,52,35);
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.menuView addSubview:addBtn];
    [[addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        HNChannelView *view = [[HNChannelView alloc]initWithFrame:CGRectMake(0, HN_SCREEN_HEIGHT, HN_SCREEN_WIDTH, HN_SCREEN_HEIGHT - HN_STATUS_BAR_HEIGHT)];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [view show];
    }];
    
    @weakify(self)
    [RACObserve(self.scrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        CGPoint offset = [x CGPointValue];
        if (offset.x > HN_SCREEN_WIDTH * (self.models.count - 1)) {
            self.scrollView.contentOffset = CGPointMake(HN_SCREEN_WIDTH * (self.models.count - 1), 0);
        }
    }];
}


#pragma mark - 需要刷新
- (void)needRefreshTableViewData {
    HNDetailVC *dvc = (HNDetailVC *)self.currentViewController;
    [dvc needRefreshTableViewData];
}

#pragma mark - WMPageController 的代理方法
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    if (self.models.count == 0 || !self.models  ) {
        return 0;
    }
    return self.models.count + 1; // 这里是为了做成今日头条的效果 故此多加了一个占位的控制器
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index > self.models.count - 1) {
        return  [[HNDetailVC alloc]init];
    }
    HNHomeTitleModel *model = self.models[index];
    HNDetailVC *detial = [[HNDetailVC alloc]init];
    detial.model = model;
    return detial;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index > self.models.count - 1) {
        return @"       ";
    }else {
        HNHomeTitleModel *model = self.models[index];
        return model.name;
    }
}
#pragma mark - WMMenuView 的代理方法
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    if (index == -1) {
        [self needRefreshTableViewData];
    }else {
        [super menuView:menu didSelesctedIndex:index currentIndex:currentIndex];
    }
}

@end
