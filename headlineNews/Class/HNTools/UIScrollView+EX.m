//
//  UIScrollView+EX.m
//  headlineNews
//
//  Created by dengweihao on 2018/1/15.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "UIScrollView+EX.h"

@implementation UIScrollView (EX)

+ (void)load {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0){
        [[self appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

@end
