//
//  HNVideoPageVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/21.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoPageVC.h"
#import "HNVideoListViewModel.h"
#import "HNVideoCell.h"
#import "HNVideoListModel.h"

static NSString *cellID = @"cellID";

@interface HNVideoPageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , weak)UITableView *tableView;
@property (nonatomic , strong)HNVideoListViewModel *videoListViewModel;
@property (nonatomic , strong)NSMutableArray *videoModels;

@end

@implementation HNVideoPageVC

- (NSMutableArray *)videoModels {
    if (!_videoModels) {
        _videoModels = [[NSMutableArray alloc]init];
    }
    return _videoModels;
}

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
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([HNVideoCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        _tableView = tableView;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    HN_WEAK_SELF
    @weakify(self);
    self.tableView.mj_header = [HNRefreshGifHeader headerWithRefreshingBlock:^{
        [wself.tableView.mj_header endRefreshing];
        [[self.videoListViewModel.videoListCommand execute:self.category] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.videoModels removeAllObjects];
            [self.videoModels addObjectsFromArray:x];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
        [[self.videoListViewModel.videoListCommand execute:self.category] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.videoModels addObjectsFromArray:x];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)refreshData {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HNVideoListModel *model = self.videoModels[indexPath.row];
    HNVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 172;
}
@end
