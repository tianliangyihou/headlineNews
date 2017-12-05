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

@property (nonatomic , weak) CAEmitterLayer *layer;
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
- (void)setAddLongPressAnimationView:(UIView *)addLongPressAnimationView {
    _addLongPressAnimationView = addLongPressAnimationView;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.3;
    [_addLongPressAnimationView addGestureRecognizer:longPress];
}
- (void)showEmitterCellsWithImages:(NSArray<UIImage *>*)images withShock:(BOOL)shouldShock onView:(UIView *)view{
    for (int i = 0; i< images.count; i++) {
        CAEmitterCell *cell = self.cells[i];
        cell.contents = (__bridge id _Nullable)(images[i].CGImage);
    }
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.name = @"emitterLayer";
    layer.position = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
    layer.emitterCells = self.cells;
    [view.layer addSublayer:layer];
    [self explodeWithView:view andLayer:layer];

}

- (void)explodeWithView:(UIView *)view andLayer:(CAEmitterLayer *)layer{
    layer.beginTime = CACurrentMediaTime();
    for (int i = 0; i < sendCountEveryTime; i++) {
        [layer setValue:@(sendCountEveryTime) forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
    }
    view.userInteractionEnabled = NO;
    [self performSelector:@selector(stopAnimationWithObj:) withObject:layer afterDelay:0.1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.userInteractionEnabled = YES;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
    });
}

- (void)stopAnimationWithObj:(id)obj {
    for (int i = 0; i < sendCountEveryTime; i++) {
        [obj setValue:@0 forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
    }
}
- (void)longPress:(UILongPressGestureRecognizer *)ges {

    if (ges.state == UIGestureRecognizerStateBegan) {
        CAEmitterLayer *layer               = [CAEmitterLayer layer];
        layer.name          = @"emitterLayer";
        layer.position  = CGPointMake(ges.view.frame.size.width/2.0, ges.view.frame.size.height/2.0);
        NSArray *images =  [[self class] defaultImages];
        for (int i = 0; i<images.count; i++) {
            CAEmitterCell *cell = self.cells[i];
            cell.contents = CFBridgingRelease([images[i] CGImage]);
        }
        layer.emitterCells = self.cells;
        [ges.view.layer addSublayer:layer];
        layer.beginTime = CACurrentMediaTime();
        for (int i = 0; i < sendCountEveryTime; i++) {
            [layer setValue:@(sendCountEveryTime) forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
        }
        _layer = layer;
    
    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled){
        [self stopAnimationWithObj:_layer];
    }
}

@end
