//
//  HNEmoticonHelper.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/7.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNEmoticonHelper.h"

@implementation HNEmoticonHelper
+ (NSDictionary *)emoticonMapper {
    return @{
             @"[玫瑰]":       [UIImage imageNamed:@"073"],
             @"[赞]":         [UIImage imageNamed:@"084"],
             @"[泪奔]":       [UIImage imageNamed:@"057"],
             @"[小鼓掌]":      [UIImage imageNamed:@"039"],
             @"[可爱]":       [UIImage imageNamed:@"059"],
             @"[灵光一闪]":    [UIImage imageNamed:@"063"],
             @"[呲牙]":       [UIImage imageNamed:@"014"],
             @"[捂脸]":       [UIImage imageNamed:@"066"],
             @"[抠鼻]":       [UIImage imageNamed:@"038"],
             @"[机智]":       [UIImage imageNamed:@"052"],
             @"[许愿]":       [UIImage imageNamed:@"049"],
             @"[送心]":       [UIImage imageNamed:@"076"],
             @"[耶]":         [UIImage imageNamed:@"087"]
             };
}
@end
