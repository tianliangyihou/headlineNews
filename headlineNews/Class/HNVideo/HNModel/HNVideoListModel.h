//
//  HNVideoListModel.h
//  headlineNews
//
//  Created by dengweihao on 2017/11/22.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNVideoUserInfoModel : NSObject
@property (nonatomic , copy)NSString *avatar_url;
//@property (nonatomic , copy)NSString *description;
@end

@interface HNVideoURLInfoModel : NSObject
@property (nonatomic , copy)NSString *main_url;
@property (nonatomic , copy)NSString *back_url_1;

@end

@interface HNVideoURLLevelModel : NSObject
@property (nonatomic , strong)HNVideoURLInfoModel *video_1; // 320p
@property (nonatomic , strong)HNVideoURLInfoModel *video_2; // 480p
@property (nonatomic , strong)HNVideoURLInfoModel *video_3; // 720p

@end

@interface HNVideoPlayInfoModel : NSObject

@property (nonatomic , assign)float video_duration;
@property (nonatomic , copy)NSString *poster_url;
@property (nonatomic , strong)HNVideoURLLevelModel *video_list;

@end

@interface HNVideoDetialModel : NSObject

@property (nonatomic , copy)NSString *media_name;
@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *video_play_info;
@property (nonatomic , strong)HNVideoPlayInfoModel *videoInfoModel;
@property (nonatomic , strong)HNVideoUserInfoModel *user_info;

@end

@interface HNVideoListModel : NSObject
@property (nonatomic , copy)NSString *code;
@property (nonatomic , copy)NSString *content;
@property (nonatomic , strong)HNVideoDetialModel *videoModel;
@property (nonatomic , assign)BOOL playing;

@end

