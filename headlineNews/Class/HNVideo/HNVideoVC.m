//
//  HNVideoVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoVC.h"
#import "HNDetailVC.h"

@interface HNVideoVC ()<UITableViewDelegate,
                        UITableViewDataSource,
                        WMPageControllerDataSource,
                        WMPageControllerDelegate>
@property (nonatomic , weak)UITableView *tableView;


@end

@implementation HNVideoVC

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(HN_NAVIGATION_BAR_HEIGHT, 0, 0, 0));
        }];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//      HN_WEAK_SELF
//    self.tableView.mj_header = [HNRefreshGifHeader headerWithRefreshingBlock:^{
//        [wself.tableView.mj_header endRefreshing];
//    }];
//    self.tableView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
//        [wself.tableView.mj_footer endRefreshingWithNoMoreData];
//    }];
    HNNavigationBar *bar = [self showCustomNavBar];
    [bar.searchSubjuct subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self.view addSubview:bar];
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - pageViewController 代理

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 10;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    return [HNDetailVC new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return @"推荐";
}



#pragma mark - 刷新数据

- (void)needRefreshTableViewData {
    NSLog(@"需要刷新了");
}


#pragma mark - delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haha"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"haha"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"indexPath - %d",indexPath.row];
    return cell;
}
@end
