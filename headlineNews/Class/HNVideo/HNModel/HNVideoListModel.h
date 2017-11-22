//
//  HNVideoListModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/22.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNVideoDetialModel : NSObject

@end

@interface HNVideoListModel : NSObject
@property (nonatomic , copy)NSString *code;
@property (nonatomic , copy)NSString *content;
@property (nonatomic , strong)HNVideoDetialModel *videoModel;

@end

