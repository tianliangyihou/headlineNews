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
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *hateBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@end
@implementation HNHomeJokeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(HNHomeJokeSummaryModel *)model {
    _model = model;
    _contentLabel.text = model.infoModel.content;
}
- (IBAction)likeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self addAnimationForSender:sender];

}
- (IBAction)hateBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self addAnimationForSender:sender];

}
- (IBAction)collectionBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self addAnimationForSender:sender];
}

- (void)addAnimationForSender:(UIButton *)sender {
    if ([sender.layer animationForKey:@"show"]) {
        [sender.layer removeAnimationForKey:@"show"];
    }
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values =@[@(0.5),@(1.2),@(1)];
    k.keyTimes =@[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode =kCAAnimationLinear;
    [sender.layer addAnimation:k forKey:@"show"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{return;}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{return;}
@end
