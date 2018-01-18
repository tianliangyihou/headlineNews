



//
//  HNImageViewContainer.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/30.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNImageViewContainer.h"
#import "HNMicroHeadlineModel.h"
#import "UIView+Frame.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HNImageView :UIImageView

@end

@implementation HNImageView
// init 也会调用
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundColor = [UIColor lightGrayColor];
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}
@end

@interface HNImageViewContainer ()
@property (nonatomic , assign)CGFloat height;
@property (nonatomic , strong)NSArray *models;

@end

@implementation HNImageViewContainer {
    NSMutableArray * _imageViews;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            HNImageView *imageView = [[HNImageView alloc]init];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)];
            [imageView addGestureRecognizer:tap];
            imageView.tag = i;
            [self addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    return _imageViews;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showWithImageLayout:(HNMicroLayout *)layout {
    _height = 0;
    NSArray *models = layout.model.detialModel.thumb_image_list;
    if (models.count == 0 || !models) {
        [self.imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = ( UIImageView *)obj;
            imageView.hidden = YES;
        }];
        return;
    }
    if (models.count > 9) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            [arr addObject:models[i]];
        }
        models = arr;
    }
    _models = models;
    [self resetImageViewStatus];
    __weak typeof(self) wself = self;
    [layout.picFrameArrays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = [(NSValue *)obj CGRectValue];
        UIImageView *imageView =  wself.imageViews[idx];
        imageView.frame = frame;
        HNMicroHeadlineImageModel *model = models[idx];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
    }];
    _height =  CGRectGetMaxY([layout.picFrameArrays.lastObject CGRectValue]);
}

- (void)resetImageViewStatus {
    int maxCount = 9;
    for (int i = (int)self.models.count; i < maxCount; i++) {
        UIImageView *imageView = self.imageViews[i];
        imageView.hidden = YES;
    }
    for (int i = 0; i < self.models.count; i++) {
        UIImageView *imageView = self.imageViews[i];
        imageView.hidden = NO;
    }
}

- (CGFloat)imageViewContainerHeight {
    return _height;
}

- (void)imageViewClick:(UITapGestureRecognizer *)tap {
    if (_imageViewCallBack) {
        _imageViewCallBack((int)tap.view.tag);
    }
}

@end
