//
//  HNNavigationBar.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/21.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface HNNavigationBar : UIView

@property (nonatomic , strong)RACSubject *searchSubjuct;

+ (instancetype)navigationBar;

@end
