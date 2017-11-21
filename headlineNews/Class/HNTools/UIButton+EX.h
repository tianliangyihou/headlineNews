//
//  UIButton+EX.h
//  CYWTest
//
//  Created by dengweihao on 2017/3/9.
//  Copyright © 2017年 dengweihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EX)

+ (UIButton *(^)(UIButtonType))button;
// 设置按钮的标题
- (UIButton *(^)(NSString *title,UIControlState status))title;
// 设置按钮背景图
- (UIButton *(^)(UIImage *backgroundImage,UIControlState status))backgroundImage;
//设置按钮的背景色
- (UIButton *(^)(UIColor *color))bgColor;
//这只按钮的边框
- (UIButton *(^)(UIColor *borderColor,CGFloat borderWidth))border;
// 设置按钮的标题颜色
- (UIButton *(^)(UIColor *titleColor))titleColor;
// 设置按钮的setImage
- (UIButton *(^)(UIImage *image,UIControlState status))setShowImage;
@end
