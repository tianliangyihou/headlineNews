//
//  HNImageViewContainer.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/30.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNMicroLayout.h"
@interface HNImageViewContainer : UIView

@property (nonatomic , strong , readonly)NSMutableArray *imageViews;
@property (nonatomic , copy)void(^imageViewCallBack)(int tag);

- (CGFloat)imageViewContainerHeight;
- (void)showWithImageLayout:(HNMicroLayout *)layout;
@end
