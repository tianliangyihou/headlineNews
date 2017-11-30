//
//  HNRefreshFooter.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNRefreshFooter.h"
#import "UIView+AnimationExtend.h"
@interface HNRefreshFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic)UIImageView *imageViewLoading;

@end

@implementation HNRefreshFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_add_video_16x16_"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    self.imageViewLoading = logo;
    self.automaticallyHidden = YES;
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.label.frame = self.bounds;
    self.imageViewLoading.bounds = CGRectMake(0, 0, 16, 16);
    self.imageViewLoading.center = CGPointMake(self.mj_w * 0.5 + 60, self.mj_h * 0.5);
    
}
#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"上拉加载数据";
            self.imageViewLoading.hidden = NO;
            [self.imageViewLoading stopRotationAnimation];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在努力加载";
            self.imageViewLoading.hidden = NO;
            [self.imageViewLoading rotationAnimation];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"木有数据了";
            self.imageViewLoading.hidden = YES;
            [self.imageViewLoading stopRotationAnimation];
            break;
        default:
            break;
    }
}
@end
