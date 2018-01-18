//
//  HNTabBarController.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//


#import "HNTabBarController.h"
#import "HNNavigationController.h"
#import "HNHomeVC.h"
#import "HNVideoVC.h"
#import "HNMicroHeadlineNewVC.h"
#import "HNMineVC.h"

#import "HNHeader.h"
#import "UIView+AnimationExtend.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UITabBar+HNTabber.h"
@interface HNTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic , weak)HNNavigationController *homeNav;
@property (nonatomic , weak)UIImageView *swappableImageView;


@end

@implementation HNTabBarController

+ (void)initialize {
    [[UITabBar appearance] setTranslucent:NO];
    [UITabBar appearance].barTintColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];

    UITabBarItem * item = [UITabBarItem appearance];

    item.titlePositionAdjustment = UIOffsetMake(0, -5);
    NSMutableDictionary * normalAtts = [NSMutableDictionary dictionary];
    normalAtts[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    normalAtts[NSForegroundColorAttributeName] = HN_TABBERBAR_GRAY_COLOR;
    [item setTitleTextAttributes:normalAtts forState:UIControlStateNormal];
    
    // 选中状态
    NSMutableDictionary *selectAtts = [NSMutableDictionary dictionary];
    selectAtts[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    selectAtts[NSForegroundColorAttributeName] = HN_MIAN_STYLE_COLOR;
    [item setTitleTextAttributes:selectAtts forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeNav = [self addChildViewControllerWithClass:[HNHomeVC class] imageName:@"home_tabbar_32x32_" selectedImageName:@"home_tabbar_press_32x32_" title:@"首页"];
    [self addChildViewControllerWithClass:[HNVideoVC class] imageName:@"video_tabbar_32x32_" selectedImageName:@"video_tabbar_press_32x32_" title:@"西瓜视频"];
    [self addChildViewControllerWithClass:[HNMicroHeadlineNewVC class] imageName:@"weitoutiao_tabbar_32x32_" selectedImageName:@"weitoutiao_tabbar_press_32x32_" title:@"微头条"];
    [self addChildViewControllerWithClass:[HNMineVC class] imageName:@"mine_tabbar_32x32_" selectedImageName:@"mine_tabbar_press_32x32_" title:@"我的"];
    self.delegate = self;
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.tabBar showBadgeOnItemIndex:0 andWithBadgeNumber:15];
    });
     [[RACScheduler mainThreadScheduler]afterDelay:1.5 * 60 schedule:^{
        [self.tabBar showBadgeOnItemIndex:0 andWithBadgeNumber:20];
    }];
    [[HNNotificationCenter rac_addObserverForName:KHomeStopRefreshNot object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.tabBar hideBadgeOnItemIndex:0];
        if (self.swappableImageView) {
            [self.swappableImageView stopRotationAnimation];
        }
        self.homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_tabbar_32x32_"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tabbar_press_32x32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}

// 添加子控制器
- (HNNavigationController *)addChildViewControllerWithClass:(Class)class
                              imageName:(NSString *)imageName
                      selectedImageName:(NSString *)selectedImageName
                                  title:(NSString *)title {
    UIViewController *vc = [[class alloc]init];
    HNNavigationController *nav = [[HNNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
    return nav;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.selectedViewController == viewController && self.selectedViewController == _homeNav) {
        if ([_swappableImageView.layer animationForKey:@"rotationAnimation"]) {
            return YES;
        }
        _homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tabber_loading_32*32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_tabber_loading_32*32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addAnnimation];
    }else {
        _homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_tabbar_32x32_"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tabbar_press_32x32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_swappableImageView stopRotationAnimation];
    }
    
    if (self.selectedViewController == viewController) {
        HNNavigationController *nav = (HNNavigationController *)viewController;
        if ([nav.viewControllers.firstObject respondsToSelector:@selector(needRefreshTableViewData)]) {
            [nav.viewControllers.firstObject needRefreshTableViewData];
        }
    }
    return YES;
}


- (void)addAnnimation {
    // 这里使用了 私有API 但是审核仍可以通过 有现成的案例
    UIControl *tabBarButton = [_homeNav.tabBarItem valueForKey:@"view"];
    UIImageView *tabBarSwappableImageView = [tabBarButton valueForKey:@"info"];
    [tabBarSwappableImageView rotationAnimation];
    _swappableImageView = tabBarSwappableImageView;
    [self.tabBar hideBadgeOnItemIndex:0];
}

@end
