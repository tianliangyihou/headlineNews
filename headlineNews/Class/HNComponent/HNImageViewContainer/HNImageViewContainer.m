



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
static CGFloat itemSpace = 5;

static inline CGFloat containerWith(){
    return [UIScreen mainScreen].bounds.size.width - 2 * 10;
}

@interface HNImageViewContainer ()
@property (nonatomic , strong)NSMutableArray *imageViews;
@property (nonatomic , assign)CGFloat height;
@property (nonatomic , strong)NSArray *models;

@end

@implementation HNImageViewContainer

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.contentMode = UIViewContentModeScaleToFill;
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

- (void)showWithImageModes:(NSArray *)models {
    if (models.count == 0 || !models) {
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
    _height = 0;
    switch (models.count) {
        case 1:
        {
            HNMicroHeadlineImageModel *model = models.firstObject;
            UIImageView *imageView = (UIImageView *)self.imageViews.firstObject;
            imageView.frame = CGRectMake(0, 0,200,150);
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
            _height = imageView.height;
        }
            break;
        case 2:
            [self layoutModel_2];
            break;
        default:
            [self layoutModelAny];
    }
    [self resetImageViewStatus];
}

- (void)layoutModel_2 {
    
    HNMicroHeadlineImageModel *firstModel = self.models.firstObject;
    HNMicroHeadlineImageModel *lastModel = self.models.lastObject;
    UIImageView *firstImageView = self.imageViews.firstObject;
    UIImageView *lastImageView = self.imageViews[1];
    CGFloat width = (containerWith() - itemSpace)/2.0;
    firstImageView.frame = CGRectMake(0, 0, width, width);
    lastImageView.frame = CGRectMake(firstImageView.width+itemSpace, 0, width, width);
    [firstImageView sd_setImageWithURL:[NSURL URLWithString:firstModel.url]];
    [lastImageView sd_setImageWithURL:[NSURL URLWithString:lastModel.url]];
    _height = firstImageView.height;
}

- (void)layoutModelAny {
    int column = self.models.count == 4 ? 2 : 3;
    CGFloat itemWidth = (containerWith() - 2 * itemSpace) / 3;
    CGFloat itemHeight = itemWidth;
    for (int i = 0; i < self.models.count; i++) {
        UIImageView *imageView = self.imageViews[i];
        CGFloat x = (i % column) * (itemSpace + itemWidth) ;
        CGFloat y = (i / column) * (itemSpace + itemHeight);
        imageView.frame = CGRectMake(x, y, itemWidth, itemHeight);
        HNMicroHeadlineImageModel *model = self.models[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
        _height = CGRectGetMaxY(imageView.frame);
    }
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
    
}

@end
