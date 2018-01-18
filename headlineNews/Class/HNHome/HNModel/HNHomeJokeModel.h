//
//  HNHomeJokeModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/12/5.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HNHomeJokeInfoModel : NSObject
@property (nonatomic , copy)NSString *content;
@property (nonatomic , assign)int comment_count;
@property (nonatomic , assign)int star_count;
@property (nonatomic , assign)int hate_count;

@end

@interface HNHomeJokeSummaryModel : NSObject

@property (nonatomic , copy)NSString *content;
@property (nonatomic , assign)int code;
@property (nonatomic , strong)HNHomeJokeInfoModel *infoModel;

// 忽略的属性
@property (nonatomic , assign)BOOL starBtnSelcetd;
@property (nonatomic , assign)BOOL hateBtnSelcetd;
@property (nonatomic , assign)BOOL collectionSelcetd;

@end
@interface HNHomeJokeModel : NSObject
@property (nonatomic , strong)NSArray *data;
@property (nonatomic , copy)NSString *message;
@end
