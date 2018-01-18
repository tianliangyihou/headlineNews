//
//  HNVideoVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoVC.h"
#import "HNVideoPageVC.h"
#import "HNVideoTitleViewModel.h"
#import "HNVideoTitleModel.h"
@interface HNVideoVC ()<WMPageControllerDataSource,
                        WMPageControllerDelegate>
@property (nonatomic , weak)UITableView *tableView;

@property (nonatomic , strong)HNVideoTitleViewModel *titleViewModel;

@property (nonatomic , strong)NSArray *models;

@end

@implementation HNVideoVC

- (HNVideoTitleViewModel *)titleViewModel {
    if (!_titleViewModel) {
        _titleViewModel = [[HNVideoTitleViewModel alloc] init];
    }
    return _titleViewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    HNNavigationBar *bar = [self showCustomNavBar];
    [bar.searchSubjuct subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    self.delegate = self;
    self.dataSource = self;
    self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 10;
    @weakify(self);
    [[self.titleViewModel.titlesCommand execute:@"title data"] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.models = x;
        [self reloadData];
    }];
    
}

#pragma mark - pageViewController 代理

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.models.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    HNVideoTitleModel *model = self.models[index];
    HNVideoPageVC *pageVC = [[HNVideoPageVC alloc]init];
    pageVC.category = model.category;
    return pageVC;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    HNVideoTitleModel *model = self.models[index];
    return model.name;
}

#pragma mark - 刷新数据
- (void)needRefreshTableViewData {
    HNVideoPageVC *pageVC = (HNVideoPageVC *)self.currentViewController;
    [pageVC needRefreshTableViewData];
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
