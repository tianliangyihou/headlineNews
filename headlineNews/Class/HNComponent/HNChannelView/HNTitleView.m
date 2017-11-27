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
    return self;
}

- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_callBack) {
        _callBack(sender.selected);
    }
}


@end
