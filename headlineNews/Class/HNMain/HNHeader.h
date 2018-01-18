//
//  HNHeader.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Frame.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "HNRefreshGifHeader.h"
#import "HNRefreshFooter.h"
#import "UIButton+EX.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "MBProgressHUD+Add.h"

#define HN_MIAN_STYLE_COLOR [UIColor colorWithRed:0.97 green:0.35 blue:0.35 alpha:1.0]
#define HN_TABBERBAR_GRAY_COLOR [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.0f]
#define HN_MIAN_GRAY_Color [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1]
#define HN_WEAK_SELF __weak typeof(self) wself = self;

#define HN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define HN_NAVIGATION_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812 ? 88 :64)
#define HN_STATUS_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812 ? 44 : 20)
#define HN_TABBER_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812 ? 83 : 49)
#define HN_BOTTOM_MARGIN ([UIScreen mainScreen].bounds.size.height == 812 ? 34 : 0)

#define HN_IID @"17769976909"
#define HN_DEVICE_ID @"41312231473"

#define HN_ASYN_GET_MAIN(...)   dispatch_async(dispatch_get_main_queue(), ^{ \
__VA_ARGS__;\
});


#define HNNotificationCenter [NSNotificationCenter defaultCenter]

UIKIT_EXTERN NSString const *HN_BASE_URL;

UIKIT_EXTERN NSString *KHomeStopRefreshNot;
