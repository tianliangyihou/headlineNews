//
//  HNHomeJokeCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/5.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeJokeCell.h"

@interface HNHomeJokeCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation HNHomeJokeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HNHomeJokeSummaryModel *)model {
    _model = model;
    _contentLabel.text = model.infoModel.content;
}
@end
