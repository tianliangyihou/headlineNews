//
//  HNVideoPageVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/21.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoPageVC.h"
#import "HNVideoListViewModel.h"
@interface HNVideoPageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak)UITableView *tableView;
@property (nonatomic , strong)HNVideoListViewModel *videoListViewModel;

@end

@implementation HNVideoPageVC

- (HNVideoListViewModel *)videoListViewModel {
    if (!_videoListViewModel) {
        _videoListViewModel = [[HNVideoListViewModel alloc]init];
    }
    return _videoListViewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _tableView = tableView;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    HN_WEAK_SELF
    self.tableView.mj_header = [HNRefreshGifHeader headerWithRefreshingBlock:^{
        [wself.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
        [wself.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    [[self.videoListViewModel.videoListCommand execute:@"video list"] subscribeNext:^(id  _Nullable x) {
    
    }];
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"indexPath -%d",indexPath.row];
    return cell;
}
@end
