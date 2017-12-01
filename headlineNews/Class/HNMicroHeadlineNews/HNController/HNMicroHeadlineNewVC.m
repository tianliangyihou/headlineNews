//
//  HNMicroHeadlineNewVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMicroHeadlineNewVC.h"
#import "HNMicroHeadlineViewModel.h"
#import "HNMicroHeadlineModel.h"
#import "HNMicroCell.h"

static NSString *const cellID = @"llb.mircoCell";
@interface HNMicroHeadlineNewVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong)NSMutableArray *datas;

@property (nonatomic , strong)HNMicroHeadlineViewModel *viewModel;

@property (nonatomic , strong)HNMicroHeadlineModel *dataModel;

@property (nonatomic , weak)UITableView *tableView;

@end

@implementation HNMicroHeadlineNewVC

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}

- (HNMicroHeadlineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HNMicroHeadlineViewModel alloc]init];
    }
    return _viewModel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        // 数据复杂效率低
        tableView.estimatedRowHeight = 400;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(40, 0, 0, 0));
        }];
        [tableView registerClass:[HNMicroCell class] forCellReuseIdentifier:cellID];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微头条";
    [self addRightItemWithImageName:@"follow_title_profile_night_18x18_"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.datas addObjectsFromArray:self.viewModel.cacheModels];
    // 请求数据
    @weakify(self);
    self.tableView.mj_header = [HNRefreshGifHeader headerWithRefreshingBlock:^{
        [[self.viewModel.microHeadlineCommand execute:@(YES)] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.dataModel = x;
            [self.datas  removeAllObjects];
            [self.datas addObjectsFromArray: self.dataModel.data];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }error:^(NSError * _Nullable error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    self.tableView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
        [[self.viewModel.microHeadlineCommand execute:@(NO)] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.dataModel = x;
            [self.datas addObjectsFromArray:self.dataModel.data];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }error:^(NSError * _Nullable error) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
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
    HNMicroCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.datas[indexPath.row];
    return cell;
}

@end
