//
//  HNHomeNewsModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/28.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNHomeNewsImageModel : NSObject
@property (nonatomic , copy)NSString *type;
@property (nonatomic , copy)NSString *width;
@property (nonatomic , copy)NSString *url;
@property (nonatomic , copy)NSString *height;
@end


@interface HNHomeNewsInfoModel : NSObject

@property (nonatomic , copy)NSString *abstract;
@property (nonatomic , copy)NSString *media_name;
@property (nonatomic , assign)int read_count;
@property (nonatomic , strong)NSArray *image_list;
@property (nonatomic , copy)NSString *display_url;
@property (nonatomic , strong)HNHomeNewsImageModel *middle_image;
//资深记者 娱评人
@property (nonatomic , copy)NSString *verified_content;
@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *keywords;
@property (nonatomic , assign)int cell_type;

@property (nonatomic , copy)NSString *article_url;

@end


@interface HNHomeNewsSummaryModel : NSObject

@property (nonatomic , copy)NSString *content;
@property (nonatomic , assign)int code;
@property (nonatomic , strong)HNHomeNewsInfoModel *infoModel;


@end



@interface HNHomeNewsModel : NSObject

@property (nonatomic , strong)NSArray *data;
@property (nonatomic , copy)NSString *message;
@property (nonatomic , copy)NSString *post_content_hint;
@property (nonatomic , assign)int total_number;

@end
