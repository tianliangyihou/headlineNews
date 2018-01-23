//
//  HNVideoCell.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/23.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNVideoListModel.h"
@interface HNVideoCell : UITableViewCell
@property (nonatomic , strong)HNVideoListModel *model;
@property (nonatomic , copy)void(^imageViewCallBack)(UIView *fatherView);

- (void)refreshCellStatus;
@end
