//
//  HNMicroCell.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/30.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNMicroLayout.h"
@interface HNMicroCell : UITableViewCell
@property (nonatomic , strong)HNMicroLayout *layout;
@property (nonatomic , copy)void (^showDetailContentBlock)(HNMicroLayout *layout);
@end
