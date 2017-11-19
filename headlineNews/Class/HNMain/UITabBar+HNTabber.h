//
//  UITabBar+HNTabber.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (HNTabber)
/*
 * 显示未读数
 */
- (void)showBadgeOnItemIndex:(NSInteger)index andWithBadgeNumber:(NSInteger)badgeNumber;

- (void)hideBadgeOnItemIndex:(NSInteger)index;

@end
