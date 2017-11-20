//
//  HNVideoVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoVC.h"


@interface HNVideoVC ()<UITableViewDelegate,UITableViewDataSource>

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
//        [wself.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    
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
