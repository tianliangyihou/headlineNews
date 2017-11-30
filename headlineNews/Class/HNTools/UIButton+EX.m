//
//  UIButton+EX.m
//  CYWTest
//
//  Created by dengweihao on 2017/3/9.
//  Copyright © 2017年 dengweihao. All rights reserved.
//

#import "UIButton+EX.h"
#import <Foundation/Foundation.h>
@implementation UIButton (EX)

+ (UIButton *(^)(UIButtonType))button {
    return ^UIButton *(UIButtonType type) {
        return [UIButton buttonWithType:type];
    };
}

- (UIButton *(^)(NSString *title, UIControlState status))title {
    return ^UIButton *(NSString *titleName, UIControlState status) {
        [self setTitle:titleName forState:status];
        return self;
    };
}


- (UIButton *(^)(UIImage *backgroundImage,UIControlState status))backgroundImage {
    return ^UIButton *(UIImage *backgroundImage,UIControlState status){
        [self setBackgroundImage:backgroundImage forState:status];
        return self;
    };
}

- (UIButton *(^)(UIColor * backgroundColor))bgColor {
    return ^UIButton *(UIColor * bgColor){
        [self setBackgroundColor:bgColor];
        return self;
    };
}

- (UIButton *(^)(UIColor *borderColor,CGFloat borderWidth))border {

    return ^UIButton *(UIColor *borderColor,CGFloat borderWidth) {
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = borderWidth;
        return self;
    };
}

- (UIButton *(^)(UIColor *))titleColor {
   return ^UIButton *(UIColor *titleColor){
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *(^)(UIImage *, UIControlState))setShowImage {
    return ^UIButton * (UIImage *currentImage,UIControlState status) {
        [self setImage:currentImage forState:status];
        return self;
    };
}

@end
