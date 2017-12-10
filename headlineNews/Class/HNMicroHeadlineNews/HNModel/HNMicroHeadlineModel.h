//
//  HNMicroHeadlineModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/29.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNMicroHeadlineImageModel : NSObject<NSCoding>
@property (nonatomic , copy)NSString *type;
@property (nonatomic , copy)NSString *width;
@property (nonatomic , copy)NSString *url;
@property (nonatomic , copy)NSString *height;

@end

@interface HNMicroHeadlineUserModel : NSObject <NSCoding>
@property (nonatomic , copy)NSString *name;
@property (nonatomic , copy)NSString *desc;
@property (nonatomic , copy)NSString *avatar_url;
@end

@interface HNMicroHeadlineDetailModel : NSObject <NSCoding>
@property (nonatomic , copy)NSString *content;
@property (nonatomic , copy)NSString *verified_content;
@property (nonatomic , assign)int read_count;
@property (nonatomic , assign)long create_time;
@property (nonatomic , strong)HNMicroHeadlineUserModel *user;
@property (nonatomic , strong)NSArray *large_image_list;
@property (nonatomic , strong)NSArray *thumb_image_list;
@property (nonatomic , strong)NSArray *ugc_cut_image_list;
@end

@interface HNMicroHeadlineSummaryModel : NSObject <NSCoding>
@property (nonatomic , copy)NSString *code;
@property (nonatomic , copy)NSString *content;
@property (nonatomic , strong)HNMicroHeadlineDetailModel *detialModel;
@end



@interface HNMicroHeadlineModel : NSObject <NSCoding>
@property (nonatomic , copy)NSString *action_to_last_stick;
@property (nonatomic , copy)NSString *has_more_to_refresh;
@property (nonatomic , copy)NSString *message;
@property (nonatomic , copy)NSString *post_content_hint;
@property (nonatomic , strong)NSArray *data;

@end
