//
//  UITabBar+HNTabber.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "UITabBar+HNTabber.h"
#import "HNHeader.h"

static int baseTag = 1000;

@implementation UITabBar (HNTabber)
- (UILabel *)specificStyleLabelWithString:(NSString *)numberStr {
    UILabel *label = [[UILabel alloc]init];
    label.text = numberStr;
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.layer.borderWidth = 1.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    label.backgroundColor = HN_MIAN_STYLE_COLOR;
    label.textColor = [UIColor whiteColor];
    label.clipsToBounds = YES;
    [label sizeToFit];
    label.height = label.height + 4;
    label.layer.cornerRadius = label.height / 2.0;
    label.width = label.width + 10;
    return label;
}


- (void)showBadgeOnItemIndex:(NSInteger)index andWithBadgeNumber:(NSInteger)badgeNumber {
    [self hideBadgeOnItemIndex:index];
    if (badgeNumber > 99) {
        badgeNumber = 99;
    }
    UILabel *targetLabel = [self specificStyleLabelWithString:[NSString stringWithFormat:@"%ld",(long)badgeNumber]];
    targetLabel.tag = baseTag + index;
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index + 0.55) / self.items.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    targetLabel.frame = CGRectMake(x, y, targetLabel.frame.size.width, targetLabel.frame.size.height);
    [self addSubview:targetLabel];
}

- (void)hideBadgeOnItemIndex:(NSInteger)index {
    for (UIView *view in self.subviews) {
        if (view.tag == baseTag + index) {
            [view removeFromSuperview];
        }
    }
}



@end
