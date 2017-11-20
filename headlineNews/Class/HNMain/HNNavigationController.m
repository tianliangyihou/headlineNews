//
//  HNNavigationController.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNNavigationController.h"
#import "HNHeader.h"
@interface HNNavigationController ()

@end

@implementation HNNavigationController

+ (void)initialize {
    [[UINavigationBar appearance] setTranslucent:NO];

    NSMutableDictionary * color = [NSMutableDictionary dictionary];
    color[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    color[NSForegroundColorAttributeName] = [UIColor blackColor];
    [[UINavigationBar appearance] setTitleTextAttributes:color];

    // 拿到整个导航控制器的外观
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    NSMutableDictionary * atts = [NSMutableDictionary dictionary];
    atts[NSFontAttributeName] = [UIFont systemFontOfSize:15.0f];
    [item setTitleTextAttributes:atts forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:0.83 green:0.24 blue:0.24 alpha:1]] forBarMetrics:UIBarMetricsDefault];
}


+ (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *theImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
