
//
//  HNMineHeaderView.m
//  headlineNews
//
//  Created by dengweihao on 2018/1/8.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "HNMineHeaderView.h"
#import "HNHeader.h"

@interface HNMineButton :UIView

@property (nonatomic , weak)UIImageView *imageV;
@property (nonatomic , weak)UILabel *label;


- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image;

@end


@interface HNMineHeaderView ()

@property (nonatomic , weak)UIView *bgView;

@property (nonatomic , weak)UIView *avatarImageV;

@end


@implementation HNMineButton

- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image {
    HNMineButton *btn = [[HNMineButton alloc]init];
    btn.label.text = title;
    btn.imageV.image = image;
    return btn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
        [self addGestureRecognizer:tap];
        UIImageView *imageView = [[UIImageView alloc]init];

        [self addSubview:imageView];
        
        CGFloat btnWidth = HN_SCREEN_WIDTH / 3.0;
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLable];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(24);
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(10);
        }];

        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnWidth);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(self).offset(-2);
        }];
        self.imageV = imageView;
        self.label = titleLable;
    }
    return self;
}


- (void)btnClick:(UITapGestureRecognizer *)tap {
    NSLog(@"%ld",tap.view.tag);
}
@end



@implementation HNMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    // 背景view
    UIView *bgView = [[UIView alloc]init];
    bgView.layer.contents = (id)[UIImage imageNamed:@"wallpaper_profile"].CGImage;
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.backgroundColor = [UIColor yellowColor];
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    // 头像
    UIImageView *avatarImageV = [[UIImageView alloc]init];
    avatarImageV.layer.cornerRadius = 60 / 2.0;
    avatarImageV.clipsToBounds = YES;
    avatarImageV.image = [UIImage imageNamed:@"weixin_sdk_login_40x40_"];
    [self addSubview:avatarImageV];
    
    // nickname
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"颤抖的老拖拉机";
    nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:nameLabel];
    
    // 今日阅读量
    UIButton *readBtn = [[UIButton alloc]init];
    readBtn.title(@"今日阅读\n70分钟",UIControlStateNormal).setShowImage([UIImage imageNamed:@"liveroom_notice_open_20x20_"],UIControlStateNormal);
    readBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    readBtn.titleLabel.numberOfLines = 0;
    readBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [readBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
    [readBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [self addSubview:readBtn];
    
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-60);
    }];
    
    [avatarImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(50);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatarImageV.mas_right).offset(8);
        make.right.mas_equalTo(self).offset(-81);
        make.height.mas_equalTo(avatarImageV);
        make.centerY.mas_equalTo(avatarImageV);
    }];
    
    [readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(avatarImageV);
        make.height.mas_equalTo(50);
    }];
    
    
    CGFloat btnWidth = HN_SCREEN_WIDTH / 3.0;
    CGFloat btnHeight = 45;
    @weakify(self);

    {
        // 动态 关注 粉丝
        NSArray *titles = @[@"动态",@"关注",@"粉丝"];
        [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.titleLabel.numberOfLines = 0;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            NSString *title = [NSString stringWithFormat:@"100\n%@",titles[idx]];
            button.title(title,UIControlStateNormal);
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(btnHeight);
                make.left.mas_equalTo(btnWidth * idx);
                make.top.mas_equalTo(avatarImageV.mas_bottom).offset(20);
            }];
        }];
    }

    {
    // 收藏 历史 夜间
        NSArray *titles = @[@"收藏",@"历史",@"夜间"];
        NSArray *images = @[
                            [UIImage imageNamed:@"favoriteicon_profile_24x24_"],
                            [UIImage imageNamed:@"history_profile_24x24_"],
                            [UIImage imageNamed:@"nighticon_profile_24x24_"]
                            ];
        [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            HNMineButton *button = [[HNMineButton alloc]initWithTitle:titles[idx] andImage:images[idx]];
            button.tag = idx;
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(idx * btnWidth);
                make.bottom.mas_equalTo(self);
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(btnHeight + 15);
            }];
        }];

    }

    _bgView = bgView;
    _avatarImageV = avatarImageV;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    //判断是否改变
    if (offset.y < 0) {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(offset.y);
        }];
    }
}


@end
