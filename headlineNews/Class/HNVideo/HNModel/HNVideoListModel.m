//
//  HNVideoListModel.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/22.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNVideoListModel.h"

@implementation HNVideoURLInfoModel

- (NSString *)main_url {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:_main_url options:0];
    return [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
}
- (NSString *)back_url_1 {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:_back_url_1 options:0];
    return [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
}

@end
@implementation HNVideoURLLevelModel


@end

@implementation HNVideoPlayInfoModel


@end

@implementation HNVideoDetialModel


@end


@implementation HNVideoListModel


@end


