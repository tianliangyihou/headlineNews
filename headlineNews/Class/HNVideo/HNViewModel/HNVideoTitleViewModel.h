//
//  HNVideoTitleViewModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/22.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface HNVideoTitleViewModel : NSObject
@property (nonatomic , strong)RACCommand *titlesCommand;
@end
