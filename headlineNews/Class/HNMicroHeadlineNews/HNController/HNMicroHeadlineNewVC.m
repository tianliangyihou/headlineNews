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
#import "HNOptionView.h"

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
        // 数据复杂效率低 这里才去抛弃的做法
        //tableView.estimatedRowHeight = 400;
        //tableView.rowHeight = UITableViewAutomaticDimension;
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
    [self.datas addObjectsFromArray:self.viewModel.cacheLayouts];
    [self configUI];
}

- (void)configUI {
    @weakify(self);
    self.tableView.mj_header = [HNRefreshGifHeader headerWithRefreshingBlock:^{
        [[self.viewModel.microHeadlineCommand execute:@(YES)] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            //self.dataModel = x;
            [self.datas  removeAllObjects];
            [self.datas addObjectsFromArray: x];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }error:^(NSError * _Nullable error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    self.tableView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
        [[self.viewModel.microHeadlineCommand execute:@(NO)] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            //self.dataModel = x;
            [self.datas addObjectsFromArray:x];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }error:^(NSError * _Nullable error) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    NSMutableArray *items = @[].mutableCopy;
    NSArray *titles = @[@"文字",@"图片",@"视频"];
    NSArray *images = @[
                        [UIImage imageNamed:@"toutiaoquan_release_text_24x24_"],
                        [UIImage imageNamed:@"toutiaoquan_release_image_24x24_"],
                        [UIImage imageNamed:@"toutiaoquan_release_video_24x24_"],
                        ];
    for (int i = 0; i < 3; i++) {
        HNOptionItem *item = [[HNOptionItem alloc]init];
        item.title = titles[i];
        item.image = images[i];
        [items addObject:item];
    }
    
    HNOptionView *optionView = [[HNOptionView alloc]initWithItems:items];
    optionView.frame = CGRectMake(0,0, HN_SCREEN_WIDTH, 40);
    [optionView setOptionClickCallback:^(HNOptionView *optionView, NSInteger btnIndex, NSString *title) {
        
    }];
    [self.view addSubview:optionView];
    CGFloat tableViewHeight = HN_SCREEN_HEIGHT - HN_NAVIGATION_BAR_HEIGHT - HN_TABBER_BAR_HEIGHT - 40;
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        CGPoint contentOffset = [x CGPointValue];
        if (contentOffset.y > 0) {
            optionView.top = contentOffset.y <= 40 ? -contentOffset.y : -40;
            self.tableView.top = floorf(contentOffset.y <= 40 ? 40 - contentOffset.y : 0);
            self.tableView.height = floorf(contentOffset.y <= 40 ? tableViewHeight + contentOffset.y : tableViewHeight + 40);
        }else {
            optionView.top = 0;
            self.tableView.top = 40;
            self.tableView.height = tableViewHeight;
        }
    }];
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
    HNMicroCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.layout = self.datas[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HNMicroLayout *layout = self.datas[indexPath.row];
    return layout.height;
}
@end
