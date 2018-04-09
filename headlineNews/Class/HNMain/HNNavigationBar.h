//
//  HNNavigationBar.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/21.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

typedef NS_ENUM(NSInteger, HNNavigationBarAction) {
    HNNavigationBarActionSend = 0,
    HNNavigationBarActionMine,
};

@interface HNNavigationBar : UIView

@property (nonatomic , strong)RACSubject *searchSubjuct;

@property (nonatomic , copy)void(^navigationBarCallBack)(HNNavigationBarAction action);


+ (instancetype)navigationBar;

@end
