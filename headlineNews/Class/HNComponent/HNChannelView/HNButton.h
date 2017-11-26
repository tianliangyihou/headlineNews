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
- (instancetype)initWithMyChannelHandleBlock:(void(^)(HNButton *))MyChannelBlock recommondChannelHandleBlock:(void(^)(HNButton *))recommondBlock;
- (void)reloadData;
@end
