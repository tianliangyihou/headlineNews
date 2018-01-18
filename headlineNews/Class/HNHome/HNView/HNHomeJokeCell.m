//
//  HNHomeJokeCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/5.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNHomeJokeCell.h"
#import "HNHeader.h"
@interface HNHomeJokeCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *hateBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (nonatomic , weak)UILabel *plusLabel;

@end
@implementation HNHomeJokeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"+1";
    // 今日头条这里并没有采用系统的字体
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.frame = CGRectMake(0, 0, 20,20);
    label.textColor = HN_MIAN_STYLE_COLOR;
    label.transform = CGAffineTransformMakeScale(0.4, 0.4);
    label.hidden = YES;
    [self.contentView addSubview:label];
    _plusLabel = label;
    _lineView.backgroundColor = HN_MIAN_GRAY_Color;
}
- (void)setModel:(HNHomeJokeSummaryModel *)model {
    _model = model;
    _contentLabel.text = model.infoModel.content;
    _likeBtn.selected = model.starBtnSelcetd;
    _hateBtn.selected = model.hateBtnSelcetd;
    _collectionBtn.selected = model.collectionSelcetd;
    [_likeBtn setTitle:[NSString stringWithFormat:@"%d",model.infoModel.star_count] forState:UIControlStateNormal];
    [_hateBtn setTitle:[NSString stringWithFormat:@"%d",model.infoModel.hate_count] forState:UIControlStateNormal];
    [_commentBtn setTitle:[NSString stringWithFormat:@"%d",model.infoModel.comment_count] forState:UIControlStateNormal];
}
- (IBAction)likeBtnClick:(UIButton *)sender {
    if ([self showLogMsg]) {
        return;
    }
    sender.selected = !sender.selected;
    self.model.infoModel.star_count += 1;
    self.model.starBtnSelcetd = sender.selected;
    [self addAnimationForSender:sender];

}
- (IBAction)hateBtnClick:(UIButton *)sender {
    if ([self showLogMsg]) {
        return;
    }
    self.model.infoModel.hate_count += 1;
    sender.selected = !sender.selected;
    self.model.hateBtnSelcetd = sender.selected;
    [self addAnimationForSender:sender];

}

- (IBAction)collectionBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.collectionSelcetd = sender.selected;
    [self addAnimationForSender:sender];
}
- (BOOL)showLogMsg {
    if (_hateBtn.selected) {
        [MBProgressHUD showError:@"您已经踩过了" toView:nil];
        return YES;
    }
    if (_likeBtn.selected) {
        [MBProgressHUD showError:@"您已经赞过了" toView:nil];
        return YES;
    }
    return NO;
}

- (void)addAnimationForSender:(UIButton *)sender {
    
    if ([sender.layer animationForKey:@"show"]) {
        [sender.layer removeAnimationForKey:@"show"];
    }
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values =@[@(0.5),@(1.2),@(1)];
    k.keyTimes =@[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode =kCAAnimationLinear;
    k.duration = 0.25;
    [sender.layer addAnimation:k forKey:@"show"];
    if (sender != self.likeBtn && sender != self.hateBtn) {
        return;
    }
    
    if (sender == _likeBtn) [_likeBtn setTitle:[NSString stringWithFormat:@"%d",self.model.infoModel.star_count] forState:UIControlStateNormal];

    if (sender == _hateBtn) [_hateBtn setTitle:[NSString stringWithFormat:@"%d",self.model.infoModel.hate_count] forState:UIControlStateNormal];
    self.plusLabel.hidden = NO;
    self.plusLabel.center = CGPointMake(sender.centerX - 10, sender.centerY - 15);
    [UIView animateWithDuration:0.25 animations:^{
        self.plusLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }completion:^(BOOL finished) {
        self.plusLabel.hidden = YES;
        self.plusLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{return;}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{return;}
@end
