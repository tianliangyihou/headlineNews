//
//  UIView+AnimationExtend.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "UIView+AnimationExtend.h"

@implementation UIView (AnimationExtend)
- (CABasicAnimation *)rotationAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    return rotationAnimation;
}
- (void)stopRotationAnimation {
    
    if ([self.layer animationForKey:@"rotationAnimation"]) {
        [self.layer removeAnimationForKey:@"rotationAnimation"];
    }
}

@end
