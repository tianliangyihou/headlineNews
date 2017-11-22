//
//  HNVideoTitleModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/22.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNVideoTitleModel : NSObject

@property (nonatomic , copy)NSString *name;

@property (nonatomic , copy)NSString *category;

@property (nonatomic , assign)int type;

@property (nonatomic , assign)int flags;

@end
