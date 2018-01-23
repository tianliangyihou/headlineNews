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
#import "HNVideoCell.h"
#import <ZFPlayer/ZFPlayer.h>

@interface HNDetailVC ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
@property (nonatomic , weak)UITableView *tableView;
@property (nonatomic , strong)HNHomeNewsCellViewModel *newsViewModel;
@property (nonatomic , strong)NSMutableArray *datas;
@property (nonatomic , weak)HNVideoListModel *playingModel;
@property (nonatomic , strong)ZFPlayerView *playerView;
@end

@implementation HNDetailVC

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = YES;
    }
    return _playerView;
}

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
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        
        UINib *videoNib = [UINib nibWithNibName:NSStringFromClass([HNVideoCell class]) bundle:nil];
        [tableView registerNib:videoNib forCellReuseIdentifier:NSStringFromClass([HNVideoCell class])];
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
            NSArray *datas = [self hn_modelArrayWithCategory:self.model.category fromModel:x];
            [self.datas addObjectsFromArray:datas];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [HNNotificationCenter postNotificationName:KHomeStopRefreshNot object:nil];
        }];
    }];
    self.tableView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.newsViewModel.newsCommand execute:self.model.category] subscribeNext:^(id  _Nullable x) {
            NSArray *datas = [self hn_modelArrayWithCategory:self.model.category fromModel:x];
            if (datas.count == 0 || !datas) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.datas addObjectsFromArray:datas];
                [self.tableView.mj_footer endRefreshing];
            }
            if (![self.model.category isEqualToString:@"video"]){
                [self.tableView reloadData];
            }else {// zfplay播放视频 直接reloadData 会终止上一个视频的播放
                NSInteger baseCount = self.datas.count - [x count];
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i < [(NSArray *)x count]; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:baseCount + i inSection:0];
                    [arr addObject:indexPath];
                }
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }];
    [self.tableView.mj_header beginRefreshing];

}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self.model.category isEqualToString:@"video"]) return;
    [self.playerView resetPlayer];
    NSArray *cells = [self.tableView visibleCells];
    for (HNVideoCell *cell in cells) {
        if (cell.model.playing) {
            [cell refreshCellStatus];
            _playingModel = nil;
        }
    }
}

- (void)needRefreshTableViewData {
    [self.tableView setContentOffset:CGPointZero];
    [self.tableView.mj_header beginRefreshing];
}

- (NSArray *)hn_modelArrayWithCategory:(NSString *)category fromModel:(id)x{
    if ([category isEqualToString:@"essay_joke"]) {
        HNHomeJokeModel *model = (HNHomeJokeModel *)x;
        return model.data;
    }else if ([category isEqualToString:@"组图"]) {
        HNHomeNewsModel *model = (HNHomeNewsModel *)x;
        return model.data;
    }else if ([category isEqualToString:@"video"]) {
        return x;
    }else {
        HNHomeNewsModel *model = (HNHomeNewsModel *)x;
        return model.data;
    }
}
-(CGFloat)hn_estimatedRowHeight {
    if ([self.model.category isEqualToString:@"essay_joke"]) {
        return 79;
    }else if ([self.model.category isEqualToString:@"组图"]) {
        return 152;
    }else if ([self.model.category isEqualToString:@"video"]) {
        return 225;
    }else {
        return 79;
    }
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
    }else if ([self.model.category isEqualToString:@"video"]) {
        HNVideoListModel *model = self.datas[indexPath.row];
        HNVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HNVideoCell class])];
        cell.model = model;
        @weakify(self);
        [cell setImageViewCallBack:^(UIView *fatherView){
            @strongify(self);
            HNVideoListModel *model = self.datas[indexPath.row];
            model.playing = YES;
            self.playingModel = model;
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"320P"] = model.videoModel.videoInfoModel.video_list.video_1.main_url;
            dic[@"480p"] = model.videoModel.videoInfoModel.video_list.video_2.main_url;
            dic[@"720p"] = model.videoModel.videoInfoModel.video_list.video_3.main_url;
            NSURL *videoURL = [NSURL URLWithString:dic[@"480p"]];
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
            playerModel.title            = model.videoModel.title;
            playerModel.videoURL         = videoURL;
            playerModel.placeholderImageURLString = model.videoModel.videoInfoModel.poster_url;
            playerModel.scrollView       = tableView;
            playerModel.resolutionDic    = dic;
            playerModel.indexPath        = indexPath;
            playerModel.fatherViewTag = fatherView.tag;
            [self.playerView playerControlView:nil playerModel:playerModel];
            [self.playerView autoPlayTheVideo];
        }];
        resultCell = cell;
    }else{
        HNHomeNewsSummaryModel *model = self.datas[indexPath.row];
        if (model.infoModel.image_list) {
            HNHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HNHomeNewsCell class])];
            cell.model = model;
            resultCell = cell;
        }else {
            HNContentNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HNContentNewsCell class])];
            cell.model = model;
            resultCell = cell;
        }
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

#pragma mark - set playingModel
/**
 重置cell的状态
 */
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (![self.model.category isEqualToString:@"video"]) return;
    HNVideoListModel *model = self.datas[indexPath.row];
    if (model.playing) {
        model.playing = NO;
        _playingModel = nil;
        [(HNVideoCell *)cell refreshCellStatus];
    }
}
- (void)setPlayingModel:(HNVideoListModel *)playingModel {
    if (_playingModel.playing) {
        _playingModel.playing = NO;
        NSInteger index = [self.datas indexOfObject:_playingModel];
        HNVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell refreshCellStatus];
    }
    _playingModel = playingModel;
}
@end
