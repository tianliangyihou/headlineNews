//
//  HNChannelView.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/21.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNChannelView.h"
#import "HNChannelModel.h"
#import "HNTitleView.h"
#import "HNButton.h"
#import "UIView+Frame.h"


#define MYCHANNEL_FRAME(i) CGRectMake(itemSpace + (i % column)* (_labelWidth + itemSpace), CGRectGetMaxY(self.header1.frame) + lineSpace + (i / column)*(labelHeight + lineSpace), _labelWidth, labelHeight)
#define RECOMMEND_FRAME(i)  CGRectMake(itemSpace + ((i) % column)* (_labelWidth + itemSpace),CGRectGetMaxY(self.divisionModel.frame) + self.header1.frame.size.height + lineSpace + ((i) / column)*(labelHeight + lineSpace), _labelWidth, labelHeight)

static CGFloat itemSpace = 10;
static CGFloat lineSpace = 10;
static int column = 4;
static CGFloat labelHeight = 40;


@interface HNChannelView ()

@property (nonatomic , strong)NSMutableArray *myChannelArr;
@property (nonatomic , strong)NSMutableArray *recommendChannelArr;
@property (nonatomic , strong)dispatch_queue_t queue;
@property (nonatomic , strong)NSMutableArray *datas;
@property (nonatomic , assign)CGFloat labelWidth;
@property (nonatomic , strong)HNTitleView *header1;
@property (nonatomic , strong)HNTitleView *header2;
@property (nonatomic , weak)HNChannelModel *divisionModel;


@end

@implementation HNChannelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _myChannelArr = [[NSMutableArray alloc]initWithArray:@[
                                                               @"推荐",@"热点",@"北京",@"视频",
                                                               @"社会",@"图片",@"娱乐",@"问答",
                                                               @"科技",@"汽车",@"财经",@"军事",
                                                               @"体育",@"段子",@"国际",@"趣图",
                                                               @"健康",@"特卖",@"房产",@"小说",
                                                               @"时尚",@"直播",@"育儿",@"搞笑",
                                                               ]];
        _recommendChannelArr = [[NSMutableArray alloc]initWithArray:@[
                                                                      @"历史",@"数码",@"美食",@"养生",
                                                                      @"电影",@"手机",@"旅游",@"宠物",
                                                                      @"情感",@"家具",@"教育",@"三农",
                                                                      @"孕产",@"文化",@"游戏",@"股票",
                                                                      @"科学",@"动漫",@"故事",@"收藏",
                                                                      @"精选",@"语录",@"星座",@"美图",
                                                                      @"辟谣",@"中国新唱将",@"微头条",@"正能量",
                                                                      @"互联网法院",@"彩票",@"快乐男声",@"中国好表演",
                                                                      @"传媒"
                                                                      ]];
        __weak typeof(self) wself = self;
        _header1 = [[HNTitleView alloc]initWithTitle:@"我的频道" subTitle:@"点击进入频道" needEditBtn:YES];
        _header1.frame = CGRectMake(0, 40, self.frame.size.width, 54);
        [_header1 setCallBack:^(BOOL selected) {
            [wself refreshEidtBtnWithStatus:selected];
        }];
        _header2 = [[HNTitleView alloc]initWithTitle:@"推荐频道" subTitle:@"点击添加频道" needEditBtn:NO];
        _header2.hidden = YES;
        _header2.frame = _header2.bounds;
        [self addSubview:_header1];
        [self addSubview:_header2];
        _labelWidth = (self.frame.size.width - itemSpace *(column + 1))/column;
        _datas = [NSMutableArray array];
        _queue = dispatch_queue_create("com.headlineNews.queue", DISPATCH_QUEUE_SERIAL);
        [self configData];
    }
    return self;
}

- (void)configData {
    __weak typeof(self) wself = self;
    dispatch_async(_queue, ^{
        for (int i = 0 ; i < wself.myChannelArr.count; i++) {
            HNChannelModel *model = [[HNChannelModel alloc]init];
            model.name = wself.myChannelArr[i];
            model.isMyChannel = YES;
            [self.datas addObject:model];
        }
        for (int i = 0 ; i < wself.recommendChannelArr.count; i++) {
            HNChannelModel *model = [[HNChannelModel alloc]init];
            model.name = wself.recommendChannelArr[i];
            model.isMyChannel = NO;
            [wself.datas addObject:model];
        }
        [wself refreshFrames];
    });
}

- (void)refreshFrames {
    for (int i = 0 ; i < self.datas.count; i++) {
        HNChannelModel *model = self.datas[i];
        model.tag = i;
        if (model.isMyChannel) {
            model.frame = MYCHANNEL_FRAME(i);
            self.divisionModel = model;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.header2.top = CGRectGetMaxY(self.divisionModel.frame) + lineSpace;
        self.header2.hidden = NO;
    });
    
    for (int i = 0 ; i < self.datas.count; i++) {
        HNChannelModel *model = self.datas[i];
        if (!model.isMyChannel) {
            int index = i - self.divisionModel.tag - 1;
             model.frame = RECOMMEND_FRAME(index);
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        for (HNChannelModel *model in self.datas) {
            HNButton *button = [[HNButton alloc]initWithMyChannelHandleBlock:^(HNButton *btn) {
                [self removeBtn:btn];
            } recommondChannelHandleBlock:^(HNButton *btn) {
                [self addBtn:btn];
            }];
            button.model = model;
            if (button.model.name.length > 2) {
                button.titleLabel.adjustsFontSizeToFitWidth = YES;
            }
            if (model.tag == self.datas.count - 1) {
                self.contentSize = CGSizeMake(0, CGRectGetMaxY(model.frame) + 30);
            }
            [self addSubview:button];
        }
        dispatch_async(_queue, ^{
            for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[HNButton class]]) {
                    [self.datas replaceObjectAtIndex:view.tag withObject:view];
                }
            }
        });
    
    });
}
#pragma mark - 刷新编辑按钮的状态

- (void)refreshEidtBtnWithStatus:(BOOL)show {
    if (!show) {
        for (HNButton *btn in self.datas) {
            if (btn.model.isMyChannel) {
                btn.deleImageView.hidden = YES;
            }else {
                btn.deleImageView.hidden = YES;
            }
        }
    }else {
        for (HNButton *btn in self.datas) {
            if (btn.model.isMyChannel) {
                btn.deleImageView.hidden = NO;
            }else {
                btn.deleImageView.hidden = YES;
            }
        }
    }
    
}

#pragma mark - 调整按钮的frame

- (void)addBtn:(HNButton *)addbtn {
    [self.datas removeObject:addbtn];
    [self.datas insertObject:addbtn atIndex:self.divisionModel.tag + 1];
    addbtn.model.isMyChannel = YES;
    int divisionIndex = self.divisionModel.tag + 1;
    for (int i = 0 ; i < self.datas.count; i++) {
        HNButton *btn = self.datas[i];
        btn.tag = i;
        btn.model.tag = i;
        if (btn.model.isMyChannel) {
            [UIView animateWithDuration:0.25 animations:^{
                btn.frame = MYCHANNEL_FRAME(i);
                btn.model.frame = btn.frame;
            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                int index = i - self.divisionModel.tag - 1;
                btn.frame = RECOMMEND_FRAME(index);
                btn.model.frame = btn.frame;
            }];
            
        }
        if (i == divisionIndex) {
            self.divisionModel = btn.model;
        }
        [btn reloadData];

    }
}
- (void)removeBtn:(HNButton *)removeBtn {
    [self.datas removeObject:removeBtn];
    [self.datas insertObject:removeBtn atIndex:self.divisionModel.tag];
    removeBtn.model.isMyChannel = NO;
    int divisionIndex = self.divisionModel.tag - 1;
    for (int i = 0 ; i < self.datas.count; i++) {
        HNButton *btn = self.datas[i];
        btn.tag = i;
        btn.model.tag = i;
        if (btn.model.isMyChannel) {
            [UIView animateWithDuration:0.25 animations:^{
                btn.frame = MYCHANNEL_FRAME(i);
                btn.model.frame = btn.frame;
            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                int index = i - self.divisionModel.tag - 1;
                btn.frame = RECOMMEND_FRAME(index);
                btn.model.frame = btn.frame;
            }];
            
        }
        if (i == divisionIndex) {
            self.divisionModel = btn.model;
        }
        [btn reloadData];
    }

}
#pragma mark - 调整按钮的header2 的尺寸
- (void)setDivisionModel:(HNChannelModel *)divisionModel {
    _divisionModel = divisionModel;
    if (![[NSThread currentThread] isMainThread]) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _header2.frame = CGRectMake(0, CGRectGetMaxY(self.divisionModel.frame)+lineSpace, self.frame.size.width, 54);
    }];
}
@end
