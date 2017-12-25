//
//  LBOptionView.h
//  headlineNews
//
//  Created by dengweihao on 2017/12/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNOptionItem : NSObject

@property (nonatomic , copy)NSString *title;

@property (nonatomic , copy)UIImage *image;

@end



@interface HNOptionView : UIView

@property (nonatomic , copy) void(^optionClickCallback)(HNOptionView *optionView,NSInteger btnIndex,NSString *title);

- (instancetype)initWithItems:(NSArray *)items;
@end
