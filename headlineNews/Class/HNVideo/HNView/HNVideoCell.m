//
//  HNVideoCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/23.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoCell.h"
#import "UIImage+EX.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HNVideoCell ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoPosterImageView;

@end

@implementation HNVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoPosterImageView.tag = 9999;
    self.videoPosterImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoPosterImageView.clipsToBounds = YES;
    self.videoPosterImageView.userInteractionEnabled = YES;
    self.videoPosterImageView.backgroundColor = [UIColor lightGrayColor];
    self.timeLabel.layer.cornerRadius = 9;
    self.timeLabel.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick)];
    [self.videoPosterImageView addGestureRecognizer:tap];
    [self.videoPosterImageView addSubview:self.playBtn];
    [self.videoPosterImageView addSubview:self.timeLabel];
    [self.videoPosterImageView addSubview:self.titleLabel];

}
- (void)setModel:(HNVideoListModel *)model {
    _model = model;
    [_videoPosterImageView sd_setImageWithURL:[NSURL URLWithString:model.videoModel.videoInfoModel.poster_url]];
    _titleLabel.text = model.videoModel.title;
    int second = model.videoModel.videoInfoModel.video_duration;
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",second/60,second %60];
    _authorLabel.text = model.videoModel.media_name;
    __weak typeof(self)wself = self;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.videoModel.user_info.avatar_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            // 高效切圆角 -> 尽量不去尝试去重写 drawRect
            wself.iconImageView.image = [image hn_drawRectWithRoundedCorner:wself.iconImageView.frame.size.width / 2.0 size:wself.iconImageView.frame.size];
        }
    }];
    if (model.playing) {
        self.iconImageView.hidden = YES;
    }else {
        [self refreshCellStatus];
    }
}
- (void)imageViewClick {
    if (_imageViewCallBack) {
        _imageViewCallBack(self.videoPosterImageView);
    }
    self.iconImageView.hidden = YES;
}
- (void)refreshCellStatus {
    self.iconImageView.hidden = NO;
}
@end
