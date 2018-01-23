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
#import <ZFPlayer/ZFPlayer.h>

static NSString *cellID = @"cellID";

@interface HNVideoPageVC ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>

@property (nonatomic , weak)UITableView *tableView;
@property (nonatomic , strong)HNVideoListViewModel *videoListViewModel;
@property (nonatomic , strong)NSMutableArray *videoModels;
@property (nonatomic , strong)ZFPlayerView *playerView;
@property (nonatomic , weak)HNVideoListModel *playingModel;

@end

@implementation HNVideoPageVC

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
        tableView.estimatedRowHeight = 0;
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

#pragma mark - 生命周期函数
- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.tableView.mj_header = [HNRefreshGifHeader headerWithRefreshingBlock:^{
        [[self.videoListViewModel.videoListCommand execute:self.category] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.videoModels removeAllObjects];
            [self.videoModels addObjectsFromArray:x];
            // For efficiency, the table view redisplays only those rows that are visible ==> reloadData并不会刷新所有行
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    // 这里每添加一次数据 -> insertObj 这里不使用reloadData是因为 --> 会打断之前的播放
    self.tableView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
        [[self.videoListViewModel.videoListCommand execute:self.category] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.videoModels addObjectsFromArray:x];
            NSInteger baseCount = self.videoModels.count - [x count];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < [(NSArray *)x count]; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:baseCount + i inSection:0];
                [arr addObject:indexPath];
            }
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    @weakify(self);
    [cell setImageViewCallBack:^(UIView *fatherView){
        @strongify(self);
        HNVideoListModel *model = self.videoModels[indexPath.row];
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 225;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
#pragma mark - set playingModel
/**
 重置cell的状态
 */
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    HNVideoListModel *model = self.videoModels[indexPath.row];
    if (model.playing) {
        model.playing = NO;
        [(HNVideoCell *)cell refreshCellStatus];
        _playingModel = nil;
    }
}
- (void)setPlayingModel:(HNVideoListModel *)playingModel {
    // 播放下一个视频之前 重置上一个的播放状态
    if (_playingModel.playing) {
        _playingModel.playing = NO;
        NSInteger index = [self.videoModels indexOfObject:_playingModel];
        HNVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell refreshCellStatus];
    }
    _playingModel = playingModel;
}
@end
