//
//  HNDetailVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/19.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNDetailVC.h"
#import "HNHomeNewsCell.h"
#import "HNHomeNewsCellViewModel.h"
static NSString *cellID = @"llb.homeCell";
@interface HNDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak)UITableView *tableView;
@property (nonatomic , strong)HNHomeNewsCellViewModel *newsViewModel;

@end

@implementation HNDetailVC

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
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([HNHomeNewsCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.newsViewModel.newsCommand execute:self.model.category] subscribeNext:^(id  _Nullable x) {
        
    }];
}
#pragma mark - delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HNHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 172;
}
@end
