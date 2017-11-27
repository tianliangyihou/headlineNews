//
//  HNVideoCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/23.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HNVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoPosterImageView;

@end

@implementation HNVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoPosterImageView.contentMode = UIViewContentModeScaleToFill;
}
- (void)setModel:(HNVideoListModel *)model {
    [_videoPosterImageView sd_setImageWithURL:[NSURL URLWithString:model.videoModel.videoInfoModel.poster_url]];
}
@end
