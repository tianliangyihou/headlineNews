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
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
    }];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        NSString *imageName = [NSString stringWithFormat:@"dropdown_loading_0%d",i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    [header setImages:images forState:MJRefreshStateRefreshing];
    [header setTitle:@"" forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [self.tableView setMj_header:header];
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
