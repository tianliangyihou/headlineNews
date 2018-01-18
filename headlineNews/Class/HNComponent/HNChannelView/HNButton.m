//
//  HNLabel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/23.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNButton.h"
#import "HNHeader.h"

// 设置按钮的阴影路径 --> 提高效率
static UIBezierPath * pathForBtn(HNButton *btn) {
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];

    float width = btn.bounds.size.width;
    float height = btn.bounds.size.height;
    float x = btn.bounds.origin.x;
    float y = btn.bounds.origin.y;
    float addWH = 2;

    CGPoint topLeft      = btn.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);

    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));

    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);

    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    [path moveToPoint:topLeft];
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    return path;
}
static inline void configMyChannelBg(HNButton *btn) {
    btn.backgroundColor = HN_MIAN_GRAY_Color;
    btn.layer.shadowOffset =  CGSizeMake(0, 0);
    btn.layer.shadowColor =  nil;
    btn.layer.shadowPath = nil;
    
}
static inline void configRecommondBg(HNButton *btn) {
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.shadowOffset =  CGSizeMake(1, 1);
    btn.layer.shadowOpacity = 0.2;
    btn.layer.shadowColor =  [UIColor blackColor].CGColor;
    btn.layer.shadowPath = pathForBtn(btn).CGPath;
}

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
        self.titleLabel.font = [UIFont systemFontOfSize:14];
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
        self.layer.cornerRadius = 4;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
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
    self.frame = model.frame;
    model.btn = self;
    if (model.isMyChannel) {
        [self setTitle:model.name forState:UIControlStateNormal];
        configMyChannelBg(self);
    }else {
        [self setTitle:[NSString stringWithFormat:@"＋%@",model.name] forState:UIControlStateNormal];
        configRecommondBg(self);
    }
    
}

- (void)reloadData {
    if (self.model.isMyChannel) {
        [self setTitle:self.model.name forState:UIControlStateNormal];
        configMyChannelBg(self);
    }else {
        [self setTitle:[NSString stringWithFormat:@"＋%@",self.model.name] forState:UIControlStateNormal];
        configRecommondBg(self);
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
