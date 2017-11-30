//
//  HNURLManager.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/20.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNURLManager.h"
#import "HNHeader.h"


@implementation HNURLManager

+ (NSString *)homeTitleURLString {
    return [NSString stringWithFormat:@"%@article/category/get_subscribed/v1/?",HN_BASE_URL];
}

+ (NSString *)homeListURLString {
    return [self videoListURLString];
}

+ (NSString *)videoTitlesURLString {
    return [NSString stringWithFormat:@"%@video_api/get_category/v1/?",HN_BASE_URL];
}
+ (NSString *)videoListURLString {
    return [NSString stringWithFormat:@"%@api/news/feed/v58/?",HN_BASE_URL];
}

+ (NSString *)microHeadlineURLString {
    return [NSString stringWithFormat:@"%@api/news/feed/v54/?",HN_BASE_URL];
}
@end
