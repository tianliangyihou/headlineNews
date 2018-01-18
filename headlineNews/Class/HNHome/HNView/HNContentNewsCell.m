//
//  HNContentNewsCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNContentNewsCell.h"
#import "HNHeader.h"
static CGFloat itemSpace = 5;
@interface HNContentNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property (weak, nonatomic) IBOutlet UILabel *deitialLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detialLabelSpace;

@end

@implementation HNContentNewsCell

- (void)setModel:(HNHomeNewsSummaryModel *)model {
    _model = model;
    _titleLabel.text = model.infoModel.title;
    if (model.infoModel.middle_image) {
        CGFloat width = (HN_SCREEN_WIDTH - 20 - 2 * itemSpace) / 3.0;
        _contentImageView.hidden = NO;
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.infoModel.middle_image.url]];
        _contentImageViewWidth.constant = width;
        _titleLabelSpace.constant  = 5;
        _detialLabelSpace.constant = 5;
    }else {
        _contentImageViewWidth.constant = 0;
        _titleLabelSpace.constant  = 0;
        _detialLabelSpace.constant = 0;
        _contentImageView.hidden = YES;
    }
    _deitialLabel.text = [NSString stringWithFormat:@"%@   %d阅读  0分钟前",model.infoModel.media_name,model.infoModel.read_count];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{return;}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{return;}
@end
