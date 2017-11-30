//
//  HNMicroCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/30.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMicroCell.h"
#import "HNHeader.h"
#import "UIImage+EX.h"
#import "HNImageViewContainer.h"
#import <SDWebImage/UIImageView+WebCache.h>
// --> 控件比较多 使用纯代码开发
@interface HNMicroCell()
@property (nonatomic , weak)UILabel *nameLabel;
@property (nonatomic , weak)UILabel *subTitleLabel;
@property (nonatomic , weak)UILabel *titleLabel;
@property (nonatomic , weak)UIButton *followBtn;
@property (nonatomic , weak)UIButton *reasonBtn;
@property (nonatomic , weak)UIImageView *iconImageView;
@property (nonatomic , weak)UIButton *starBtn;
@property (nonatomic , weak)UIButton *commentBtn;
@property (nonatomic , weak)UIButton *shareBtn;
@property (nonatomic , weak)UILabel *readLabel;
@property (nonatomic , weak)HNImageViewContainer *containerView;

@end

@implementation HNMicroCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UIImageView *iconImageView = [[UIImageView alloc]init];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:14];
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *reasonBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"dislikeicon_textpage_26x14_"],UIControlStateNormal);
    
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 0;
    HNImageViewContainer *imageContainerView = [[HNImageViewContainer alloc]init];
    UILabel *readLabel = [[UILabel alloc]init];
    readLabel.font = [UIFont systemFontOfSize:12];
    readLabel.textColor = [UIColor lightGrayColor];
    
    UIButton *starBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"dislikeicon_textpage_26x14_"],UIControlStateNormal).title(@"0dsad",UIControlStateNormal).titleColor([UIColor blackColor]);
    UIButton *commentBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"dislikeicon_textpage_26x14_"],UIControlStateNormal).title(@"032131",UIControlStateNormal).titleColor([UIColor blackColor]);
    UIButton *shareBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"dislikeicon_textpage_26x14_"],UIControlStateNormal).title(@"01233333",UIControlStateNormal).titleColor([UIColor blackColor]);
    
    starBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [starBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [starBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    
    [self.contentView addSubview:iconImageView];
    _iconImageView = iconImageView;
    
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [self.contentView addSubview:followBtn];
    _followBtn = followBtn;
    
    [self.contentView addSubview:reasonBtn];
    _reasonBtn = reasonBtn;
    
    [self.contentView addSubview:subTitleLabel];
    _subTitleLabel = subTitleLabel;
    
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [self.contentView addSubview:imageContainerView];
    _containerView = imageContainerView;
    

    [self.contentView addSubview:readLabel];
    _readLabel = readLabel;
    

    [self.contentView addSubview:starBtn];
    _starBtn = starBtn;

    [self.contentView addSubview:commentBtn];
    _commentBtn = commentBtn;
    
    [self.contentView addSubview:shareBtn];
    _shareBtn = shareBtn;
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(10);
    }];
    
    [reasonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(iconImageView);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(14);

    }];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(reasonBtn.mas_left).offset(-10);
        make.centerY.mas_equalTo(iconImageView);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).offset(8);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(iconImageView.mas_top);
        make.right.mas_equalTo(followBtn.mas_left).offset(-10);
    }];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).offset(8);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.right.mas_equalTo(followBtn.mas_left).offset(-10);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_lessThanOrEqualTo(120);
//        make.height.mas_equalTo(30);
    }];
    
    [imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(10);
    }];
    
    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageContainerView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(10);
    }];
    
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(readLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView).multipliedBy(1 / 3.0);
        make.height.mas_equalTo(40);
    }];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(readLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(starBtn.mas_right);
        make.width.mas_equalTo(self.contentView).multipliedBy(1 / 3.0);
        make.height.mas_equalTo(40);
    }];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(readLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(commentBtn.mas_right);
        make.width.mas_equalTo(self.contentView).multipliedBy(1 / 3.0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
}

- (void)setModel:(HNMicroHeadlineSummaryModel *)model {
    _model = model;
    @weakify(self);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.detialModel.user.avatar_url] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self);
        if (!image) {
            return ;
        }
        self.iconImageView.image = [image hn_drawRectWithRoundedCorner:20 size:self.iconImageView.frame.size];
    }];
    self.nameLabel.text = model.detialModel.user.name;
    self.subTitleLabel.text = model.detialModel.user.desc;
    self.titleLabel.text = model.detialModel.content;
    if (model.detialModel.read_count > 10000) {
        self.readLabel.text = [NSString stringWithFormat:@"%.1f万人阅读",model.detialModel.read_count/10000.0];
    }else {
        self.readLabel.text = [NSString stringWithFormat:@"%d人阅读",model.detialModel.read_count];
    }
    [self.containerView showWithImageModes:model.detialModel.thumb_image_list];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.containerView.imageViewContainerHeight);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{return;}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{return;}

@end
