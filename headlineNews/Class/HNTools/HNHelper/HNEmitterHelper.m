//
//  HNEmitterHelper.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/3.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNEmitterHelper.h"
#import <AudioToolbox/AudioToolbox.h>

static HNEmitterHelper *helper = nil;

@interface HNEmitterHelper()
@property (nonatomic , strong)NSTimer *timer;
@property (nonatomic , weak)CAEmitterLayer *emitterLayer;

@end

@implementation HNEmitterHelper


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shock) userInfo:nil repeats:YES];
    }
    return _timer;
}

+ (instancetype)defaultHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[HNEmitterHelper alloc]init];
    });
    return helper;
}

- (void)showEmitterCellsWithImages:(NSArray<UIImage *>*)images withShock:(BOOL)shouldShock onView:(UIView *)view{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(view.frame.size.width / 2.0, view.frame.size.height / 2.0);
    NSMutableArray *cells = [NSMutableArray array];
    for (int i = 0; i < images.count; i++) {
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.birthRate = 5;
        cell.emissionLongitude = 2 *M_PI - M_PI /4.0;
        cell.emissionRange = M_PI / 2.0;
        cell.velocity = 1000;
        cell.velocityRange = 200;
        cell.lifetime = 4;
        cell.lifetimeRange = 2.5;
        cell.scale = 0.5;
        cell.scaleRange = 0.1;
        cell.yAcceleration = 100;
        cell.xAcceleration = 10;
        cell.alphaRange = 0.2;
        cell.alphaSpeed = -0.1;
        cell.contents = (__bridge id _Nullable)(images[i].CGImage);
        [cells addObject:cell];
    }
    emitterLayer.emitterCells = cells;
    [view.layer addSublayer:emitterLayer];
    emitterLayer.beginTime = CACurrentMediaTime();
    _emitterLayer = emitterLayer;
    if (shouldShock) {
        [self timer];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
- (void)shock {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)stopAnimation {
    [self.timer invalidate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.emitterLayer removeFromSuperlayer];
    });
}
+ (NSArray<UIImage *>*)defaultImages {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) {
        int x = arc4random() % 100 + 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%03d",x]];
        [arr addObject:image];
    }
    return arr;
}
@end
