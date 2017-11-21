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
    UIButton *(^titleBlock)(NSString *title ,UIControlState status) = ^(NSString *titleName, UIControlState status) {
        [self setTitle:titleName forState:status];
        return self;
    };
    return titleBlock;
}


- (UIButton *(^)(UIImage *backgroundImage,UIControlState status))backgroundImage {

    UIButton *(^backgroundImage)(UIImage *backgroundImage,UIControlState status) = ^(UIImage *backgroundImage,UIControlState status){
        [self setBackgroundImage:backgroundImage forState:status];
        return self;
    };
    return backgroundImage;
}

- (UIButton *(^)(UIColor * backgroundColor))bgColor {
    UIButton *(^bgColor)(UIColor * bgColor) = ^(UIColor * bgColor){
        [self setBackgroundColor:bgColor];
        return self;
    };
    return bgColor;
}

- (UIButton *(^)(UIColor *borderColor,CGFloat borderWidth))border {

    UIButton *(^borderBlock)(UIColor *borderColor,CGFloat borderWidth) = ^(UIColor *borderColor,CGFloat borderWidth) {
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = borderWidth;
        return self;
    };
    return borderBlock;
}

- (UIButton *(^)(UIColor *))titleColor {
    UIButton *(^titleColorBlock)(UIColor *titleColor) = ^(UIColor *titleColor){
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        return self;
    };
    return titleColorBlock;
}

- (UIButton *(^)(UIImage *, UIControlState))setShowImage {
    return ^UIButton * (UIImage *currentImage,UIControlState status) {
        [self setImage:currentImage forState:status];
        return self;
    };
}

@end
