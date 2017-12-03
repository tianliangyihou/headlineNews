//
//  HNEmitterHelper.h
//  headlineNews
//
//  Created by dengweihao on 2017/12/3.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNEmitterHelper : NSObject
+ (instancetype)defaultHelper;
- (void)showEmitterCellsWithImages:(NSArray<UIImage *>*)images withShock:(BOOL)shouldShock onView:(UIView *)view;
- (void)stopAnimation;
+ (NSArray <UIImage *>*)defaultImages;
@end
