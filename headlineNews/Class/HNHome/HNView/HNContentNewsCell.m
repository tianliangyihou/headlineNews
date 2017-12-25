//
//  HNContentNewsCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNContentNewsCell.h"
#import "HNHeader.h"

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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HNHomeNewsSummaryModel *)model {
    _model = model;
    _titleLabel.text = model.infoModel.title;
    if (model.infoModel.image_list.count == 1) {
        _contentImageView.hidden = NO;
        HNHomeNewsImageModel *rightModel = (HNHomeNewsImageModel *)model.infoModel.image_list.firstObject;
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:rightModel.url]];
        _contentImageViewWidth.constant = 68.5;
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
