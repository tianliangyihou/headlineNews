//
//  HNLabel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/23.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNButton.h"
#import "UIButton+EX.h"
#import <Masonry/Masonry.h>
#import "UIView+Frame.h"
@interface HNButton()

@property (nonatomic , copy)void (^myChannelBlock)(HNButton *);

@property (nonatomic , copy)void (^recommondBlock)(HNButton *);

@property (nonatomic , copy)void (^beginBlock)(HNButton *);

@property (nonatomic , copy)void (^moveBlock)(HNButton *,UILongPressGestureRecognizer *);

@property (nonatomic , copy)void (^endBlock)(HNButton *);

@end

@implementation HNButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"closeicon_repost_18x18_"]];
        _deleImageView = imageView;
        [self addSubview:_deleImageView];
        [_deleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(18);
            make.right.top.mas_equalTo(self);
        }];
        imageView.hidden = YES;
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (instancetype)initWithMyChannelHandleBlock:(void (^)(HNButton *))MyChannelBlock recommondChannelHandleBlock:(void (^)(HNButton *))recommondBlock {
    self = [super init];
    if (self) {
        _recommondBlock = recommondBlock;
        _myChannelBlock = MyChannelBlock;
    }
    return self;
}

- (void)addLongPressBeginBlock:(void (^)(HNButton *))beginBlock longPressMoveBlock:(void (^)(HNButton *, UILongPressGestureRecognizer *))moveBlock longPressEndBlock:(void (^)(HNButton *))endBlock {
    _beginBlock = beginBlock;
    _endBlock = endBlock;
    _moveBlock = moveBlock;
}


- (void)setModel:(HNChannelModel *)model {
    _model = model;
    self.tag = model.tag;
    if (model.isMyChannel) {
        [self setTitle:model.name forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"common_button_white"] forState:UIControlStateNormal];
    }else {
        [self setTitle:[NSString stringWithFormat:@"＋%@",model.name] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"common_button_white_highlighted"] forState:UIControlStateNormal];
    }
    self.frame = model.frame;
}

- (void)reloadData {
    if (self.model.isMyChannel) {
        [self setTitle:self.model.name forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"common_button_white"] forState:UIControlStateNormal];
    }else {
        [self setTitle:[NSString stringWithFormat:@"＋%@",self.model.name] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"common_button_white_highlighted"] forState:UIControlStateNormal];
    }
}

- (void)btnClick:(HNButton *)btn {
    
    if (btn.model.isMyChannel) {
        if (_myChannelBlock) {
            _myChannelBlock(btn);
        }
    }else {
        if (_recommondBlock) {
            _recommondBlock(btn);
        }
    }
}

- (void)btnLong:(UILongPressGestureRecognizer *)ges {
    if (self.model.isMyChannel == NO || self.deleImageView.hidden == YES) {
        return;
    }
    if (ges.state == UIGestureRecognizerStateBegan) {
        CGPoint center = self.center;
        [UIView animateWithDuration:0.25 animations:^{
            self.width = self.width + 10;
            self.height = self.height + 8;
            self.center = center;
        }];
        if (_beginBlock) {
            _beginBlock(self);
        }
    }else if (ges.state == UIGestureRecognizerStateEnded) {
        if (_endBlock) {
            _endBlock(self);
        }
    }else if (ges.state == UIGestureRecognizerStateChanged) {
        if (_moveBlock) {
            _moveBlock(self,ges);
        }
    }else if (ges.state == UIGestureRecognizerStateCancelled) {
        if (_endBlock) {
            _endBlock(self);
        }
    }
}

@end
