//
//  HNMicroCell.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/30.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNMicroCell.h"
#import "HNHeader.h"
#import "UIImage+EX.h"
#import "HNImageViewContainer.h"
#import "LBPhotoBrowserManager.h"
#import "HNEmitterHelper.h"
#import "HNEmoticonHelper.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <YYText/YYText.h>

@interface HNMicroCell() <UIGestureRecognizerDelegate>
@property (nonatomic , weak)UILabel *nameLabel;
@property (nonatomic , weak)UILabel *subTitleLabel;
@property (nonatomic , weak)YYLabel *titleLabel;
@property (nonatomic , weak)UIButton *followBtn;
@property (nonatomic , weak)UIButton *reasonBtn;
@property (nonatomic , weak)UIImageView *iconImageView;
@property (nonatomic , weak)UIButton *starBtn;
@property (nonatomic , weak)UIButton *commentBtn;
@property (nonatomic , weak)UIButton *shareBtn;
@property (nonatomic , weak)UILabel *readLabel;
@property (nonatomic , weak)HNImageViewContainer *containerView;

@end

@implementation HNMicroCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
        [self configFrame];
    }
    return self;
}

- (void)configUI {
    UIImageView *iconImageView = [[UIImageView alloc]init];

    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = hn_cell_name_Label_Font;
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.titleLabel.font = hn_cell_name_Label_Font;
    [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *reasonBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"dislikeicon_textpage_26x14_"],UIControlStateNormal);
    
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.font = hn_cell_subTitle_Label_Font;
    subTitleLabel.textColor = [UIColor lightGrayColor];

    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 24;
    YYLabel *titleLabel = [[YYLabel alloc]init];
    titleLabel.numberOfLines = hn_cell_content_label_max_lines;
    titleLabel.linePositionModifier = modifier;
    titleLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    [titleLabel setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"%@",[text attributedSubstringFromRange:range].string);
    }];

    @weakify(self);
    HNImageViewContainer *imageContainerView = [[HNImageViewContainer alloc]init];
    [imageContainerView setImageViewCallBack:^(int tag) {
        @strongify(self);
        NSMutableArray *items = [NSMutableArray array];
        for (int i = 0 ; i < self.layout.model.detialModel.large_image_list.count; i++) {
            HNMicroHeadlineImageModel *model = self.layout.model.detialModel.large_image_list[i];
            UIImageView *imageView = self.containerView.imageViews[i];
            LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:model.url frame:imageView.frame placeholdImage:imageView.image placeholdSize:imageView.frame.size];
            [items addObject:item];
        }
        //https://github.com/tianliangyihou/LBPhotoBrowser
        [[LBPhotoBrowserManager defaultManager] showImageWithWebItems:items selectedIndex:tag fromImageViewSuperView:self.containerView].lowGifMemory = YES;
        [[[LBPhotoBrowserManager defaultManager] addLongPressShowTitles:@[@"保存",@"分享",@"取消"]] addTitleClickCallbackBlock:^(UIImage *image, NSIndexPath *indexPath, NSString *title) {
            NSLog(@"%@",title);
        }];
    }];
    UILabel *readLabel = [[UILabel alloc]init];
    readLabel.font = hn_cell_read_Label_Font;
    readLabel.textColor = [UIColor lightGrayColor];
    
    UIButton *starBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"comment_like_icon_16x16_"],UIControlStateNormal).title(@"1000",UIControlStateNormal).titleColor([UIColor blackColor]);
    UIButton *commentBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"comment_feed_24x24_"],UIControlStateNormal).title(@"123",UIControlStateNormal).titleColor([UIColor blackColor]);
    UIButton *shareBtn = UIButton.button(UIButtonTypeCustom).setShowImage([UIImage imageNamed:@"feed_share_24x24_"],UIControlStateNormal).title(@"123",UIControlStateNormal).titleColor([UIColor blackColor]);
    
    starBtn.titleLabel.font = hn_cell_read_Label_Font;
    [starBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [starBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    commentBtn.titleLabel.font = hn_cell_read_Label_Font;
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    shareBtn.titleLabel.font = hn_cell_read_Label_Font;
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    
    
    [self.contentView addSubview:iconImageView];
    _iconImageView = iconImageView;
    
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [self.contentView addSubview:followBtn];
    _followBtn = followBtn;
    
    [self.contentView addSubview:reasonBtn];
    _reasonBtn = reasonBtn;
    
    [self.contentView addSubview:subTitleLabel];
    _subTitleLabel = subTitleLabel;
    
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [self.contentView addSubview:imageContainerView];
    _containerView = imageContainerView;
    
    [self.contentView addSubview:readLabel];
    _readLabel = readLabel;
    
    [self.contentView addSubview:starBtn];
    _starBtn = starBtn;
    
    [self.contentView addSubview:commentBtn];
    _commentBtn = commentBtn;
    
    [self.contentView addSubview:shareBtn];
    _shareBtn = shareBtn;
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
    tap.delegate = self;
    [self.contentView addGestureRecognizer:tap];
    
    //添加动画
    [HNEmitterHelper defaultHelper].addLongPressAnimationView = starBtn;
    [starBtn addTarget:self action:@selector(starBtnBeginAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addMoreButton];
}

- (void)addMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    @weakify(self);
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSLog(@"%@",self.layout.model.detialModel.content);
        @strongify(self);
        if (self.showDetailContentBlock) {
            self.showDetailContentBlock(self.layout);
        }
    };
    
    [text yy_setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:@"全文"]];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"全文"]];
    text.yy_font = hn_cell_content_Label_Font;
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    self.titleLabel.truncationToken = truncationToken;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[YYLabel class]]) {
        YYLabel *label = (YYLabel *)touch.view;
        YYTextRange *textRange = [label.textLayout textRangeAtPoint:[touch locationInView:label]];
        if (!textRange) return YES;
        id obj = [label.attributedText yy_attribute:YYTextHighlightAttributeName atIndex:textRange.asRange.location];
        return obj? NO :YES;
    }
    return YES;
}

- (void)titleLabelClick:(UITapGestureRecognizer *)tap {
    if (self.showDetailContentBlock) {
        self.showDetailContentBlock(self.layout);
    }
}

- (void)configFrame {
    _iconImageView.frame = CGRectMake(10, 20, 40, 40);
    
    _reasonBtn.frame = CGRectMake(0, 0, 26, 14);
    _reasonBtn.right = HN_SCREEN_WIDTH - 10;
    _reasonBtn.centerY = _iconImageView.centerY;
    
    _followBtn.frame = CGRectMake(0, 0, 40, 40);
    _followBtn.right = _reasonBtn.left - 10;
    _followBtn.centerY = _iconImageView.centerY;
    
    _nameLabel.frame = CGRectMake(0, 0, 0, 25);
    _nameLabel.left = _iconImageView.right + 8;
    _nameLabel.width = 120;
    _nameLabel.top = _iconImageView.top;
    
    _subTitleLabel.frame = CGRectMake(0, 0, 0, 15);
    _subTitleLabel.top = _nameLabel.bottom;
    _subTitleLabel.width = 120;
    _subTitleLabel.left = _iconImageView.right + 8;
    
    _titleLabel.frame = CGRectMake(10, _iconImageView.bottom + 10, HN_SCREEN_WIDTH - 20, 200);
    _containerView.frame = CGRectMake(10, _titleLabel.bottom + 5, HN_SCREEN_WIDTH - 20, 0);
    _readLabel.frame = CGRectMake(10, _containerView.bottom + 5, HN_SCREEN_WIDTH - 20, 10);
    
    _starBtn.frame = CGRectMake(0, _readLabel.bottom + 15, HN_SCREEN_WIDTH / 3.0, 40);
    _commentBtn.frame = CGRectMake(HN_SCREEN_WIDTH / 3.0, _readLabel.bottom + 15, HN_SCREEN_WIDTH / 3.0, 40);
    _shareBtn.frame = CGRectMake(HN_SCREEN_WIDTH / 3.0 * 2, _readLabel.bottom + 15, HN_SCREEN_WIDTH / 3.0, 40);
    
    //imageView的圆角
    CALayer *iconLayer = _iconImageView.layer;
    iconLayer.cornerRadius = _iconImageView.height / 2;
    iconLayer.shouldRasterize = YES;
    iconLayer.rasterizationScale = [UIScreen mainScreen].scale;
    iconLayer.masksToBounds = YES;
}


- (void)setLayout:(HNMicroLayout *)layout {
    _layout = layout;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:layout.model.detialModel.user.avatar_url]];
    self.nameLabel.text = layout.model.detialModel.user.name;
    self.subTitleLabel.text = layout.model.detialModel.user.desc;
    self.readLabel.text = layout.readCountStr;
    self.titleLabel.height = [layout contentHeight];
    self.titleLabel.attributedText = layout.hn_content;
    [self.containerView showWithImageLayout:layout];
    self.containerView.frame = CGRectMake(10, self.titleLabel.bottom + 5, SCREEN_WIDTH - 20, [self.containerView imageViewContainerHeight]);
    [self hn_layout];
}
- (void)hn_layout {
    self.readLabel.top = self.containerView.bottom + 5;
    self.starBtn.top = self.readLabel.bottom + 15;
    self.commentBtn.top = self.readLabel.bottom + 15;
    self.shareBtn.top = self.readLabel.bottom + 15;
}

#pragma mark - btn的点击事件

- (void)starBtnBeginAnimation:(UIButton *)btn {
    [[HNEmitterHelper defaultHelper] showEmitterCellsWithImages:[HNEmitterHelper defaultImages] withShock:YES onView:btn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{return;}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{return;}

@end
