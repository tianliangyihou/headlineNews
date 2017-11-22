//
//  HNVideoVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoVC.h"
#import "HNVideoPageVC.h"
#import "HNNetWorkManager.h"
#import "HNURLManager.h"
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
    [self.view addSubview:bar];
    self.delegate = self;
    self.dataSource = self;
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
    return [HNVideoPageVC new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    HNVideoTitleModel *model = self.models[index];
    return model.name;
}



#pragma mark - 刷新数据

- (void)needRefreshTableViewData {
    NSLog(@"需要刷新了");
}



@end
