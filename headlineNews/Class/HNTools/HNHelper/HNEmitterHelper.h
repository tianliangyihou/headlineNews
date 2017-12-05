//
//  HNEmitterHelper.h
//  headlineNews
//
//  Created by dengweihao on 2017/12/3.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNEmitterHelper : NSObject
// 需要长按手势的View
@property (nonatomic , weak)UIView *addLongPressAnimationView;

+ (instancetype)defaultHelper;
- (void)showEmitterCellsWithImages:(NSArray<UIImage *>*)images withShock:(BOOL)shouldShock onView:(UIView *)view;
+ (NSArray <UIImage *>*)defaultImages;
@end
