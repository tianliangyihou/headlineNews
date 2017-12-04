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

static CGFloat sendCountEveryTime = 5;

@interface HNEmitterHelper()

@property (strong, nonatomic) CAEmitterLayer *explosionLayer;
@property (nonatomic , strong)NSMutableArray *cells;

@end

@implementation HNEmitterHelper


+ (NSArray<UIImage *>*)defaultImages {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < sendCountEveryTime; i++) {
        int x = arc4random() % 100 + 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%03d",x]];
        [arr addObject:image];
    }
    return arr;
}
+ (instancetype)defaultHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[HNEmitterHelper alloc]init];
    });
    return helper;
}

- (NSMutableArray *)cells {
    if (!_cells) {
        _cells = [[NSMutableArray alloc]init];
    }
    return _cells;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    for (int i = 0; i < sendCountEveryTime; i++) {
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.name           = [NSString stringWithFormat:@"explosion_%d",i];
        cell.alphaRange     = 0.5;
        cell.alphaSpeed     = -0.5;
        cell.lifetime       = 4;
        cell.lifetimeRange  = 2;
        cell.velocity       = 600;
        cell.velocityRange  = 200.00;
        cell.scale          = 0.5;
        cell.yAcceleration = 600;
        cell.emissionLongitude = 2 *M_PI - M_PI /4.0;
        cell.emissionRange = M_PI / 2.0;
        [self.cells addObject:cell];

    }

}

- (void)showEmitterCellsWithImages:(NSArray<UIImage *>*)images withShock:(BOOL)shouldShock onView:(UIView *)view{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.3;
    [view addGestureRecognizer:longPress];
    for (int i = 0; i< images.count; i++) {
        CAEmitterCell *cell = self.cells[i];
        cell.contents = (__bridge id _Nullable)(images[i].CGImage);
    }
    if (_explosionLayer) {
        [_explosionLayer removeFromSuperlayer];
    }
    _explosionLayer               = [CAEmitterLayer layer];
    _explosionLayer.name          = @"emitterLayer";
    _explosionLayer.position  = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
    _explosionLayer.emitterCells  = self.cells;
    [view.layer addSublayer:_explosionLayer];
    [self explode];

}

- (void)explode {
    self.explosionLayer.beginTime = CACurrentMediaTime();
    for (int i = 0; i < sendCountEveryTime; i++) {
        [self.explosionLayer setValue:@(sendCountEveryTime) forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
    }
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.1];
}

- (void)stopAnimation {    
    for (int i = 0; i < sendCountEveryTime; i++) {
        [self.explosionLayer setValue:@0 forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
    }
}
- (void)longPress:(UILongPressGestureRecognizer *)ges {
    NSLog(@"长按手势 - HNcell");
    if (ges.state == UIGestureRecognizerStateBegan) {
        for (int i = 0; i < sendCountEveryTime; i++) {
            [self.explosionLayer setValue:@5 forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
        }
    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled){
        [self stopAnimation];
    }
}
@end
