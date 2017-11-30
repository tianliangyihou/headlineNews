//
//  HNTitleView.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/24.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNTitleView.h"

@interface HNTitleView()
@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *subTitle;
@property (nonatomic , assign)BOOL needEditBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation HNTitleView


+ (instancetype)HNTitleView {
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle
                  needEditBtn:(BOOL)needEditBtn {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:0].firstObject;
    self.titleLabel.text = title;
    self.subtitleLabel.text = subTitle;
    self.editBtn.hidden = !needEditBtn;
    self.editBtn.layer.cornerRadius = 10;
    self.editBtn.layer.borderColor = [UIColor colorWithRed:0.93 green:0.37 blue:0.47 alpha:1.0].CGColor;
    self.editBtn.layer.borderWidth = 1;
    self.subtitleLabel.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0];
    return self;
}

- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.subtitleLabel.text = @"拖拽可以排序";
    }else {
        self.subtitleLabel.text = @"点击进入频道";
    }
    if (_callBack) {
        _callBack(sender.selected);
    }
}


@end
