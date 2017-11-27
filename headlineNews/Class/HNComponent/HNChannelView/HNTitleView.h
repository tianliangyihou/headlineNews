//
//  HNTitleView.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/24.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNTitleView : UIView
@property (nonatomic , copy)void(^callBack)(BOOL selected);
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle needEditBtn:(BOOL)needEditBtn;
@end
