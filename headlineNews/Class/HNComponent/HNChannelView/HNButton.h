//
//  HNLabel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/23.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNChannelModel.h"
@interface HNButton : UIButton
@property (nonatomic , strong)HNChannelModel *model;
@property (nonatomic , weak)UIImageView *deleImageView;

- (instancetype)initWithMyChannelHandleBlock:(void(^)(HNButton *))MyChannelBlock                                 recommondChannelHandleBlock:(void(^)(HNButton *))recommondBlock;
//void(^)(HNButton * btn) 这么写会有参数提示
- (void)addLongPressBeginBlock:(void(^)(HNButton * btn))beginBlock
            longPressMoveBlock:(void(^)(HNButton * btn,UILongPressGestureRecognizer *ges))moveBlock
             longPressEndBlock:(void(^)(HNButton * btn))endBlock;
- (void)reloadData;
@end
