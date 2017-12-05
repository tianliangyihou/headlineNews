//
//  HNHomeNewsCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/28.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeNewsCell.h"
#import "HNHeader.h"
static CGFloat itemSpace = 5;
@interface HNHomeNewsCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint2;

@end

@implementation HNHomeNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *constraints = @[_heightConstraint,_widthConstraint,
                             _heightConstraint1,_widthConstraint1,
                             _heightConstraint2,_widthConstraint2,
                             ];
    CGFloat width = (HN_SCREEN_WIDTH - 20 - 2 * itemSpace) / 3.0;
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.constant = width;
    }
    _marginConstraint.constant = itemSpace;
    _titleLabel.numberOfLines = 2;
    _infoLabel.font = [UIFont systemFontOfSize:10];
}
- (void)setModel:(HNHomeNewsSummaryModel *)model {
    _model = model;
    _titleLabel.text = model.infoModel.title;
    if (model.infoModel.image_list.count == 3) {
        _leftImageView.hidden = NO;
        _rightImageView.hidden = NO;
        _middleImageView.hidden = NO;
        NSArray *imageModels  = model.infoModel.image_list;
        HNHomeNewsImageModel *leftModel = (HNHomeNewsImageModel *)imageModels.firstObject;
        HNHomeNewsImageModel *rightModel = (HNHomeNewsImageModel *)imageModels.lastObject;
        HNHomeNewsImageModel *middleModel = (HNHomeNewsImageModel *)imageModels[1];
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:leftModel.url]];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:rightModel.url]];
        [_middleImageView sd_setImageWithURL:[NSURL URLWithString:middleModel.url]];
    }else {
        _leftImageView.hidden = YES;
        _rightImageView.hidden = YES;
        _middleImageView.hidden = YES;
    }
    _infoLabel.text = [NSString stringWithFormat:@"%@   %d阅读  0分钟前",model.infoModel.media_name,model.infoModel.read_count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{return;}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{return;}
@end
