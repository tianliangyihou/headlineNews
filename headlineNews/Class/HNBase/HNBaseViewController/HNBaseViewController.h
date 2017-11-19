//
//  HNBaseViewController.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/19.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNBaseViewController : UIViewController

- (void)addLeftItemWithImageName:(NSString *)imageName;

- (void)addRightItemWithImageName:(NSString *)imageName;

- (void)addLeftItemWithText:(NSString *)text;

- (void)addRightItemWithText:(NSString *)text;

- (void)leftItemAction;

- (void)rightItemAction;
@end
