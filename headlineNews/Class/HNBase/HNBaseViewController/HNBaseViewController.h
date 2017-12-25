//
//  HNBaseViewController.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/19.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNHeader.h"
#import "HNNavigationBar.h"
#import <YYCache/YYCache.h>
#import "MBProgressHUD+Add.h"
@protocol BaseViewControllerRefreshProtocol <NSObject>

@optional
- (void)needRefreshTableViewData;

- (void)rightItemAction;

@end

@interface HNBaseViewController : UIViewController <BaseViewControllerRefreshProtocol>

- (void)addLeftItemWithImageName:(NSString *)imageName;

- (void)addRightItemWithImageName:(NSString *)imageName;

- (void)addLeftItemWithText:(NSString *)text;

- (void)addRightItemWithText:(NSString *)text;

- (void)leftItemAction;

- (HNNavigationBar *)showCustomNavBar;

@end


