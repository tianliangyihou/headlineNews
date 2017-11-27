//
//  HNRefreshGifHeader.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNRefreshGifHeader.h"

#define HNRefreshStateRefreshingImagesCount 16

@interface HNRefreshGifHeader()

@property (weak, nonatomic) UILabel *label;

@end
@implementation HNRefreshGifHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
    self.mj_h = 50;
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i< HNRefreshStateRefreshingImagesCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    self.label = label;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.label.frame = CGRectMake(0, self.mj_h - 15, self.mj_w, 15);
    self.gifView.frame = CGRectMake((self.mj_w - 25) / 2.0, 5, 25, 25);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"下拉推荐";
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开推荐";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"推荐中";
            break;
        default:
            break;
    }
}




@end
