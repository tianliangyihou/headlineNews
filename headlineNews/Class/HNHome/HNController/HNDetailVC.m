//
//  HNDetailVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/19.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNDetailVC.h"
#import "HNHomeNewsCellViewModel.h"
#import "HNHomeNewsModel.h"
#import "HNHomeJokeModel.h"
#import "HNHomeNewsCell.h"
#import "HNHomeJokeCell.h"
#import "HNHomeWebVC.h"
#import "HNContentNewsCell.h"

@interface HNDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak)UITableView *tableView;
@property (nonatomic , strong)HNHomeNewsCellViewModel *newsViewModel;
@property (nonatomic , strong)NSMutableArray *datas;

@end

@implementation HNDetailVC

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}

- (HNHomeNewsCellViewModel *)newsViewModel {
    if (!_newsViewModel) {
        _newsViewModel = [[HNHomeNewsCellViewModel alloc]init];
    }
    return _newsViewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 152;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        UINib *newsNib = [UINib nibWithNibName:NSStringFromClass([HNHomeNewsCell class]) bundle:nil];
        [tableView registerNib:newsNib forCellReuseIdentifier:NSStringFromClass([HNHomeNewsCell class])];
        
        UINib *contentNib = [UINib nibWithNibName:NSStringFromClass([HNContentNewsCell class]) bundle:nil];
        [tableView registerNib:contentNib forCellReuseIdentifier:NSStringFromClass([HNContentNewsCell class])];
        
        UINib *jokeNib = [UINib nibWithNibName:NSStringFromClass([HNHomeJokeCell class]) bundle:nil];
        [tableView registerNib:jokeNib forCellReuseIdentifier:NSStringFromClass([HNHomeJokeCell class])];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.tableView.mj_header = [HNRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.newsViewModel.newsCommand execute:self.model.category] subscribeNext:^(id  _Nullable x) {
            [self.datas removeAllObjects];
            HNHomeNewsModel *model = (HNHomeNewsModel *)x;
            [self.datas addObjectsFromArray:model.data];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [HNNotificationCenter postNotificationName:KHomeStopRefreshNot object:nil];
        }];
    }];
    self.tableView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.newsViewModel.newsCommand execute:self.model.category] subscribeNext:^(id  _Nullable x) {
            HNHomeNewsModel *model = (HNHomeNewsModel *)x;
            if (model.data.count == 0 || !model.data) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.datas addObjectsFromArray:model.data];
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];

}

- (void)needRefreshTableViewData {
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *resultCell = nil;
    if ([self.model.category isEqualToString:@"essay_joke"]) {
        HNHomeJokeSummaryModel *model = self.datas[indexPath.row];
        HNHomeJokeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HNHomeJokeCell class])];
        cell.model = model;
        resultCell = cell;
    }else if([self.model.category isEqualToString:@"组图"]) {
        HNHomeNewsSummaryModel *model = self.datas[indexPath.row];
        HNHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HNHomeNewsCell class])];
        cell.model = model;
        resultCell = cell;
    }else {
        HNHomeNewsSummaryModel *model = self.datas[indexPath.row];
        HNContentNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HNContentNewsCell class])];
        cell.model = model;
        resultCell = cell;
    }
    return resultCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.model.category isEqualToString:@"组图"]) {
        HNHomeNewsSummaryModel *model = self.datas[indexPath.row];
        HNHomeWebVC *webVC = [[HNHomeWebVC alloc]init];
        webVC.urlString = model.infoModel.article_url;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}


@end
