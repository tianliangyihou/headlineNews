//
//  HNNavigationController.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNNavigationController : UINavigationController
@property (nonatomic , strong)UIImage *defaultImage;
- (void)startPopGestureRecognizer;
- (void)stopPopGestureRecognizer;
@end
