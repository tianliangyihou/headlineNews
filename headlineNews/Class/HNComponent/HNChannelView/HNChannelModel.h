//
//  HNChannelModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/23.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNButton;
@interface HNChannelModel : NSObject
@property (nonatomic , copy)NSString *name;
@property (nonatomic , assign)BOOL isMyChannel;
@property (nonatomic , assign)CGRect frame;
@property (nonatomic , assign)int tag;
@property (nonatomic , assign)BOOL hideDeleBtn;
@property (nonatomic , weak)HNButton *btn;

@end
