
//
//  HNMicroVideoVC.m
//  headlineNews
//
//  Created by dengweihao on 2018/4/8.
//  Copyright © 2018年 vcyber. All rights reserved.
//


#import "HNMicroVideoVC.h"
#import "HNMicroVideoCollectionViewCell.h"

#import "HNMicroVideoViewModel.h"

#define HN_CELL_HEIGHT ((667 - 49 - 64)/2.0)
#define HN_CELL_SAPCE 1.0
static  NSString * cellID = @"lb.cell";
@interface HNMicroVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , weak)UICollectionView *collectionView;
@property (nonatomic , strong)HNMicroVideoViewModel *videoVM;

@end

@implementation HNMicroVideoVC

- (HNMicroVideoViewModel *)videoVM {
    if (!_videoVM) {
        _videoVM = [[HNMicroVideoViewModel alloc]init];
    }
    return _videoVM;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((HN_SCREEN_WIDTH - HN_CELL_SAPCE) /2.0,HN_CELL_HEIGHT);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = HN_CELL_SAPCE;
        flowLayout.minimumInteritemSpacing = HN_CELL_SAPCE;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat top = HN_NAVIGATION_BAR_HEIGHT - 44;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,top,HN_SCREEN_WIDTH,HN_SCREEN_HEIGHT - top - HN_TABBER_BAR_HEIGHT) collectionViewLayout:flowLayout];
        [self.view addSubview:collectionView];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        [self collectionViewRegisterCellWithCollectionView:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (void)collectionViewRegisterCellWithCollectionView:(UICollectionView *)collentionView {
    [collentionView registerClass:[HNMicroVideoCollectionViewCell class] forCellWithReuseIdentifier:cellID];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    @weakify(self);
    self.collectionView.mj_header = [HNRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.videoVM.microVideoCommand execute:@""] subscribeNext:^(id  _Nullable x) {
            
        }];
    }];
    self.collectionView.mj_footer = [HNRefreshFooter footerWithRefreshingBlock:^{
        
    }];
}

#pragma mark - collectionView的代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HNMicroVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
}
@end
