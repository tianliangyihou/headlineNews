//
//  HNMicroContentVC.m
//  headlineNews
//
//  Created by dengweihao on 2018/1/17.
//  Copyright © 2018年 vcyber. All rights reserved.
//

#import "HNMicroContentVC.h"
#import <YYText/YYText.h>
@interface HNMicroContentVC ()<YYTextViewDelegate>
@property (nonatomic , strong)HNMicroLayout *layout;

@end

@implementation HNMicroContentVC

- (instancetype)initWithLayout:(HNMicroLayout *)layout
{
    self = [super init];
    if (self) {
        _layout = layout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微头条";
    [self configUI];
}

- (void)configUI {
    [self addLeftItemWithImageName:@"lefterbackicon_titlebar_24x24_"];
    [self addRightItemWithImageName:@"More_24x24_"];    
    YYTextView *textView = [[YYTextView alloc]init];
    textView.attributedText = self.layout.hn_content;
    textView.delegate = self;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-HN_BOTTOM_MARGIN);
        make.left.right.mas_equalTo(self.view);
        //这里没有设置偏移64的原因 https://www.jianshu.com/p/b11769831fef
        make.top.mas_equalTo(self.view);
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

@end
