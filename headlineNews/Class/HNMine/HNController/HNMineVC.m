//
//  HNMineVC.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMineVC.h"
#import "HNMineHeaderView.h"
@interface HNMineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak)UITableView *tableView;
@property (nonatomic , strong)NSArray <NSArray<NSString *> *> *titles;

@end

@implementation HNMineVC

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.tableHeaderView = [self addUserInfoHeader];
        tableView.tableFooterView = [UIView new];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _tableView = tableView;
        
    }
    return _tableView;
}


- (UIView *)addUserInfoHeader {
    HNMineHeaderView *headerView = [[HNMineHeaderView alloc]init];
    headerView.frame = CGRectMake(0, 0, HN_SCREEN_WIDTH, 240);
    return headerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[
                @[@"消息通知",@"私信"],
                @[@"头条商城",@"京东特供"],
                @[@"用户反馈",@"系统设置"]
                 ];
    self.navigationController.navigationBar.hidden = YES;
    [self tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles[section].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"hahah";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        // 初始化cell
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        UIImageView *arrowImageView = [[UIImageView alloc]init];
        arrowImageView.image = [UIImage imageNamed:@"setting_rightarrow_night_8x14_"];
        [cell.contentView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(14);
            make.centerY.mas_equalTo(cell.textLabel.mas_centerY);
            make.right.mas_equalTo(cell.contentView).offset(-15);
        }];
    }
    NSString *title = self.titles[indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HN_SCREEN_WIDTH, 10)];
    colorView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    return colorView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    HNMineHeaderView *view = (HNMineHeaderView *)self.tableView.tableHeaderView;
    [view scrollViewDidScroll:scrollView];
}

@end
