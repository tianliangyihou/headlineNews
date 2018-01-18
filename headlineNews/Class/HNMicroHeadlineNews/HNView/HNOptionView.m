
//
//  LBOptionView.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNOptionView.h"
#import "HNHeader.h"

@interface HNOptionView ()

@property (nonatomic , strong)NSMutableArray *items;

@end


@interface HNOptionButton : UIButton
@property (nonatomic , weak)UIView *lineView;

@end

@implementation HNOptionItem


@end

@implementation HNOptionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0,0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setUI];
    }
    return self;
}
- (void)setUI {
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo((self.height - 20) /2.0);
    }];
    _lineView = lineView;
}

@end




@implementation HNOptionView

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super init]) {
        _items = @[].mutableCopy;
        [_items addObjectsFromArray:items];
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI {
    int count = self.items.count;
    CGFloat width = HN_SCREEN_WIDTH / count;
    @weakify(self);
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        HNOptionItem *item = self.items[idx];
        HNOptionButton *button = [[HNOptionButton alloc]initWithFrame:CGRectMake(idx * width, 0, width,35)];
        [self addSubview:button];
        button.tag = idx;
        button.setShowImage(item.image,UIControlStateNormal).title(item.title,UIControlStateNormal);
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == 2) {
            button.lineView.hidden = YES;
        }
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HN_MIAN_GRAY_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(5);
    }];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)btnClick:(HNOptionButton *)btn {
    if (_optionClickCallback) {
        HNOptionItem *item = self.items[btn.tag];
        _optionClickCallback(self,btn.tag,item.title);
    }
}


@end
